# Fluxo da API: unidade gestora, pessoas e cadastros subsequentes

Esta documentacao descreve o comportamento atualmente implementado pela API. Os exemplos usam a base `http://localhost:3000`; substitua-a pela URL do ambiente desejado.

## Visao do dominio

```text
Administrador da plataforma
  -> Unidade gestora (ADMINISTRACAO ou ESCOLA)
       -> responsavel inicial da unidade
            -> Pessoa global + Usuario + Perfil na unidade
       -> se for ESCOLA: setores padrao criados automaticamente

Unidade gestora selecionada
  -> Pessoa global (cadastro e identificacao por CPF)
       -> Estudante da unidade
            -> saude e responsaveis
            -> Usuario ALUNO, se acessa_portal=true
            -> Usuarios RESPONSAVEL_LEGAL para responsaveis ativos
       -> Responsavel da unidade
       -> Funcionario da unidade
            -> especialidades e setor-funcao
            -> Usuario/perfis derivados das funcoes
       -> Predios -> blocos -> ambientes
```

`GPessoa` e a identidade reutilizavel: o mesmo CPF representa uma unica pessoa ativa no sistema. `EEstudante`, `EResponsavel` e `RFuncionario` sao papeis dessa pessoa. Estudante e funcionario so podem ter um papel ativo por pessoa; responsavel pode existir uma vez por unidade.

## Convencoes comuns

Todos os endpoints abaixo estao em `/api/v1` e, exceto `login`, `refresh` e `logout`, exigem o cabecalho:

```http
Authorization: Bearer <access_token>
Content-Type: application/json
```

Para recursos escopados pela unidade, use tambem:

```http
X-Unidade-Gestora-Id: <id-da-unidade>
```

O cabecalho pode ser substituido pelo parametro `g_unidade_gestora_id`, mas o cabecalho e o meio recomendado. Um usuario comum so acessa unidades nas quais possui um `UserPerfil` ativo. Se ele possuir mais de uma unidade e nao informar o contexto, a API retorna `422`. O perfil `ADMIN_PLATAFORMA` pode consultar tudo sem selecionar unidade ou selecionar qualquer unidade pelo cabecalho.

Formato de sucesso:

```json
{
  "success": true,
  "message": "...",
  "data": {},
  "timestamp": "2026-09-02T12:00:00-04:00"
}
```

Formato de erro de regra/validacao:

```json
{
  "success": false,
  "message": "Nao foi possivel ...",
  "errors": ["campo mensagem de erro"],
  "timestamp": "2026-09-02T12:00:00-04:00"
}
```

Os `GET` de colecao respondem com paginacao:

```json
{
  "success": true,
  "data": {
    "pagy": {
      "current_page": 1,
      "total_pages": 1,
      "total_count": 1,
      "per_page": 10
    },
    "items": []
  }
}
```

Use `?page=1&per_page=10` quando necessario. Os indices aceitam filtros Ransack via `q`, por exemplo `?q[nome_cont]=Maria`.

## 1. Autenticacao e escolha da unidade

### Login

`POST /api/v1/login`

```json
{
  "login": "123.456.789-00",
  "password": "senha"
}
```

`login` aceita CPF ou e-mail. Em caso de sucesso (`200`), `data` possui tokens de acesso e renovacao. Use o valor de `access_token` no cabecalho `Authorization`. Cinco tentativas de senha invalidas bloqueiam o usuario.

```json
{
  "success": true,
  "message": "Login realizado com sucesso",
  "data": {
    "access_token": "<jwt>",
    "refresh_token": "<jwt>",
    "token_type": "Bearer",
    "expires_in": 1800
  }
}
```

O access token expira em 30 minutos. O refresh token expira em 30 dias e e rotacionado a cada login ou renovacao: um novo par invalida o refresh token anterior.

### Perfil, permissoes e unidades acessiveis

`GET /api/v1/meu_usuario`

Retorna dados do usuario e uma lista de `perfis`. Cada item tem `vinculo_id`, `unidade_gestora`, `perfil`, `permissoes` e os `templates` de interface. Pegue `perfis[].unidade_gestora.id` e envie-o como `X-Unidade-Gestora-Id` nas proximas chamadas.

Exemplo reduzido:

```json
{
  "success": true,
  "data": {
    "usuario": { "id": 10, "nome": "Diretora", "cpf": "12345678900" },
    "perfis": [
      {
        "vinculo_id": 31,
        "unidade_gestora": { "id": 7, "nome": "Escola Centro", "tipo_unidade": "ESCOLA" },
        "perfil": { "id": 2, "codigo": "ADMIN_ESCOLA", "descricao": "Administrador da Escola" },
        "permissoes": [],
        "templates": []
      }
    ]
  }
}
```

Renovacao e saida:

| Metodo | URL | Corpo | Resposta |
| --- | --- | --- | --- |
| `POST` | `/api/v1/refresh` | `{ "refresh_token": "<jwt>" }` | `200`, novo par de tokens |
| `DELETE` | `/api/v1/logout` | `{ "refresh_token": "<jwt>" }` | `204`, invalida o refresh token |

## 2. Criar a unidade gestora

Somente `ADMIN_PLATAFORMA` pode criar e remover unidades. Para criar uma escola, informe obrigatoriamente um responsavel inicial. A criacao e atomica: se pessoa, responsavel, usuario ou perfil falharem, a unidade nao e criada.

### Referenciais necessarios

Obtenha previamente os IDs de sexo, bairro, perfil e, se aplicavel, funcao:

| Objetivo | Endpoint |
| --- | --- |
| Perfil do responsavel | `GET /api/v1/u_perfis` |
| Funcao do responsavel (alternativa ao perfil) | `GET /api/v1/r_funcoes` |
| Sexo | `GET /api/v1/g_sexos` |
| Bairro | `GET /api/v1/g_bairros` |

**Lacuna atual:** `g_tipo_unidade_gestora_id` e obrigatorio no banco, mas `config/routes.rb` nao expoe `GET /g_tipos_unidades_gestoras`. Os tipos sao referenciais carregados por importacao (`ADMINISTRACAO` e `ESCOLA`). O frontend precisa receber o ID por configuracao/bootstrap ate que uma rota de leitura seja adicionada. Alternativamente, o endpoint aceita `tipo_unidade: "ESCOLA"` ou `"ADMINISTRACAO"`, que resolve o tipo internamente.

### Criar escola

`POST /api/v1/g_unidades_gestoras`

```json
{
  "g_unidade_gestora": {
    "tipo_unidade": "ESCOLA",
    "nome": "Escola de Musica Centro",
    "razao_social": "Escola de Musica Centro LTDA",
    "nome_fantasia": "EM Centro",
    "cnpj": "12345678000199",
    "email": "contato@emcentro.test",
    "telefone": "(69) 99999-0000",
    "status": "ATIVA",
    "identidade_visual": {
      "cor_primaria": "#003B5C",
      "cor_secundaria": "#F4B942"
    },
    "g_unidade_gestora_responsavel_attributes": {
      "u_perfil_id": 2,
      "principal": true,
      "ativo": true,
      "data_inicio": "2026-09-02",
      "g_pessoa_attributes": {
        "nome": "Ana Diretora",
        "cpf": "12345678901",
        "data_nascimento": "1980-01-20",
        "g_sexo_id": 2,
        "email": "ana.diretora@emcentro.test",
        "telefone": "(69) 99999-0001"
      }
    }
  }
}
```

O responsavel deve ter `u_perfil_id` **ou** `r_funcao_id`; pelo menos um e obrigatorio. Se a pessoa tiver usuario novo, e-mail e obrigatorio para o envio da definicao de senha. Quando a escola e criada, os setores padrao (diretoria, secretaria, corpo docente, entre outros) sao criados automaticamente.

Resposta `201` reduzida:

```json
{
  "success": true,
  "message": "Unidade gestora criada com sucesso",
  "data": {
    "id": 7,
    "tipo_unidade": "ESCOLA",
    "nome": "Escola de Musica Centro",
    "status": "ATIVA",
    "g_tipo_unidade_gestora": { "id": 2, "codigo": "ESCOLA", "descricao": "Escola" },
    "responsavel_principal": {
      "id": 18,
      "principal": true,
      "ativo": true,
      "g_pessoa": { "id": 42, "nome": "Ana Diretora", "cpf": "12345678901" },
      "u_perfil": { "id": 2, "codigo": "ADMIN_ESCOLA", "descricao": "Administrador da Escola" }
    }
  }
}
```

Outras operacoes:

| Metodo | URL | Uso |
| --- | --- | --- |
| `GET` | `/api/v1/g_unidades_gestoras` | Lista unidades no escopo do usuario. |
| `GET` | `/api/v1/g_unidades_gestoras/:id` | Detalha uma unidade autorizada. |
| `PATCH` | `/api/v1/g_unidades_gestoras/:id` | Atualiza campos e pode criar/atualizar o responsavel pelo mesmo corpo. |
| `DELETE` | `/api/v1/g_unidades_gestoras/:id` | Soft delete, apenas administrador da plataforma. |

## 3. Pessoa: criar, reutilizar e atualizar

`GPessoa` nao possui escopo de unidade no controller atual. Portanto, `GET /api/v1/g_pessoas` lista pessoas globalmente para qualquer usuario autenticado. Ao consumir ou evoluir a API, trate isto como dado sensivel: CPF, contato e endereco estao na resposta.

Campos aceitos em `g_pessoa`: `nome`, `nome_social`, `cpf`, `data_nascimento`, `g_sexo_id`, `email`, `telefone`, `whatsapp`, `foto`, `cep`, `logradouro`, `numero`, `g_bairro_id`. O CPF e normalizado para somente digitos e deve ser unico entre registros nao excluidos.

### Pessoa sem acesso ao sistema

`POST /api/v1/g_pessoas`

```json
{
  "g_pessoa": {
    "nome": "Joao da Silva",
    "cpf": "987.654.321-00",
    "data_nascimento": "1992-10-15",
    "g_sexo_id": 1,
    "email": "joao@example.test",
    "telefone": "(69) 98888-0000",
    "g_bairro_id": 3
  }
}
```

Resposta `201`: a chave `data` traz `id`, dados pessoais, `g_sexo` e `g_bairro` (com cidade/UF quando associados).

### Pessoa com acesso

Para criar usuario junto com a pessoa, acrescente `u_perfil_id`, `g_unidade_gestora_id` e `ativo`. E-mail e obrigatorio quando for um usuario novo.

```json
{
  "g_pessoa": {
    "nome": "Joao da Silva",
    "cpf": "98765432100",
    "email": "joao@example.test",
    "u_perfil_id": 3,
    "g_unidade_gestora_id": 7,
    "ativo": true
  }
}
```

Esse fluxo cria `User` vinculado a pessoa e `UserPerfil` vinculado ao perfil e a unidade. A senha inicial e aleatoria; a definicao de senha e enviada por e-mail.

Operacoes diretas:

| Metodo | URL | Corpo |
| --- | --- | --- |
| `GET` | `/api/v1/g_pessoas` | Sem corpo. |
| `GET` | `/api/v1/g_pessoas/:id` | Sem corpo. |
| `POST` | `/api/v1/g_pessoas` | `{ "g_pessoa": { ... } }` |
| `PATCH` | `/api/v1/g_pessoas/:id` | `{ "g_pessoa": { ...campos alterados... } }` |
| `DELETE` | `/api/v1/g_pessoas/:id` | Sem corpo; falha se houver papel/usuario que impeça a exclusao. |

### Regra de CPF nos fluxos aninhados

Estudantes, responsaveis, funcionarios e responsaveis da unidade usam a mesma resolucao:

1. Informe `g_pessoa_id` para reutilizar uma pessoa conhecida.
2. Ou envie `g_pessoa_attributes` com CPF ainda inexistente para criar a pessoa.
3. Se o CPF ja existir, ela e reutilizada e seus dados nao mudam por padrao.
4. Envie `atualizar_g_pessoa: true` para atualizar os dados da pessoa existente.
5. Se enviar ID e CPF, os dois devem corresponder a mesma pessoa.

Exemplo de reuso com atualizacao controlada:

```json
{
  "g_pessoa_id": 42,
  "atualizar_g_pessoa": true,
  "g_pessoa_attributes": {
    "cpf": "12345678901",
    "telefone": "(69) 99999-9999"
  }
}
```

## 4. Estudante, responsavel e saude

Use o contexto da unidade em todos estes endpoints:

```http
X-Unidade-Gestora-Id: 7
```

Antes do cadastro, carregue os referenciais usados no formulario:

| Dado | Endpoint |
| --- | --- |
| Sexo | `GET /api/v1/g_sexos` |
| Bairro | `GET /api/v1/g_bairros` |
| Parentesco | `GET /api/v1/g_parentescos` |
| Alergia | `GET /api/v1/g_alergias` |
| Necessidade especifica | `GET /api/v1/g_necessidades_especificas` |

### Criar estudante completo

`POST /api/v1/e_estudantes`

O ID da unidade e aplicado pelo cabecalho para usuarios comuns. Pode ser enviado no corpo, mas se for diferente do contexto a requisicao retorna `403`.

```json
{
  "e_estudante": {
    "registro_aluno": "ALU-2026-0001",
    "acessa_portal": true,
    "emancipado": false,
    "proprio_responsavel": false,
    "g_pessoa_attributes": {
      "nome": "Lucas Almeida",
      "cpf": "11122233344",
      "data_nascimento": "2012-05-10",
      "g_sexo_id": 1,
      "g_bairro_id": 3,
      "email": "lucas@example.test"
    },
    "e_saude_estudante_attributes": {
      "observacoes_gerais": "Evitar atividades intensas sem acompanhamento.",
      "e_saudes_estudantes_alergias_attributes": [
        { "g_alergia_id": 1, "observacao": "Evitar contato", "ativo": true }
      ],
      "e_saudes_estudantes_necessidades_attributes": [
        {
          "g_necessidade_especifica_id": 2,
          "observacao": "Acompanhamento pedagogico",
          "laudo_arquivo": "laudo-lucas.pdf",
          "data_laudo": "2026-08-01",
          "ativo": true
        }
      ]
    },
    "e_estudantes_responsaveis_attributes": [
      {
        "g_parentesco_id": 1,
        "responsavel_principal": true,
        "responsavel_financeiro": true,
        "autorizado_buscar": true,
        "data_inicio": "2026-09-02",
        "ativo": true,
        "e_responsavel_attributes": {
          "ativo": true,
          "g_pessoa_attributes": {
            "nome": "Maria Almeida",
            "cpf": "55566677788",
            "data_nascimento": "1980-03-15",
            "g_sexo_id": 2,
            "g_bairro_id": 3,
            "email": "maria.almeida@example.test"
          }
        }
      }
    ]
  }
}
```

Resposta `201` (estrutura reduzida):

```json
{
  "success": true,
  "message": "Estudante criado com sucesso",
  "data": {
    "id": 20,
    "registro_aluno": "ALU-2026-0001",
    "acessa_portal": true,
    "g_unidade_gestora": { "id": 7, "nome": "Escola de Musica Centro", "tipo_unidade": "ESCOLA" },
    "g_pessoa": { "id": 50, "nome": "Lucas Almeida", "cpf": "11122233344" },
    "e_saude_estudante": { "id": 9, "observacoes_gerais": "..." },
    "e_estudantes_responsaveis": [
      {
        "id": 14,
        "responsavel_principal": true,
        "e_responsavel": { "id": 12, "g_pessoa": { "id": 51, "nome": "Maria Almeida" } }
      }
    ]
  }
}
```

Efeitos de acesso: com `acessa_portal: true`, a pessoa do estudante recebe o perfil `ALUNO`; cada responsavel ativo recebe o perfil `RESPONSAVEL_LEGAL`. Ambos exigem e-mail para um usuario novo. Tudo e revertido se algum acesso nao puder ser criado.

Regras principais:

- `registro_aluno` e unico dentro da unidade.
- Um estudante so pode ter uma pessoa ativa vinculada.
- Responsavel e estudante devem pertencer a mesma unidade.
- Um mesmo responsavel, estudante e parentesco nao podem ser repetidos.
- Se o parentesco tiver `permite_outro: true`, `parentesco_outro` e obrigatorio; nos demais casos deve ficar vazio.
- `data_fim` nao pode ser anterior a `data_inicio`.

### Operacoes do estudante e saude

| Metodo | URL | Corpo |
| --- | --- | --- |
| `GET` | `/api/v1/e_estudantes` | Lista estudantes da unidade. |
| `GET` | `/api/v1/e_estudantes/:id` | Detalha estudante, pessoa, saude e responsaveis. |
| `POST` | `/api/v1/e_estudantes` | Corpo completo acima ou apenas os campos necessarios. |
| `PATCH` | `/api/v1/e_estudantes/:id` | Mesmo envelope; itens aninhados existentes precisam de `id`; use `_destroy: true` para remover. |
| `DELETE` | `/api/v1/e_estudantes/:id` | Soft delete. |
| `GET` | `/api/v1/e_saudes_estudantes` | Lista saudes somente de estudantes da unidade. |
| `PATCH` | `/api/v1/e_saudes_estudantes/:id` | Atualiza observacoes, alergias e necessidades. |

Exemplo de atualizacao de saude:

```json
{
  "e_saude_estudante": {
    "e_estudante_id": 20,
    "observacoes_gerais": "Observacao atualizada",
    "e_saudes_estudantes_alergias_attributes": [
      { "id": 8, "_destroy": true },
      { "g_alergia_id": 3, "observacao": "Novo cuidado", "ativo": true }
    ]
  }
}
```

### Responsavel cadastrado separadamente

Use quando o responsavel deve existir antes de ser ligado a um estudante.

`POST /api/v1/e_responsaveis`

```json
{
  "e_responsavel": {
    "ativo": true,
    "g_pessoa_attributes": {
      "nome": "Carlos Almeida",
      "cpf": "99988877766",
      "g_sexo_id": 1,
      "email": "carlos@example.test"
    }
  }
}
```

Depois, no estudante, envie `e_responsavel_id` dentro de `e_estudantes_responsaveis_attributes`.

| Metodo | URL |
| --- | --- |
| `GET`, `POST` | `/api/v1/e_responsaveis` |
| `GET`, `PATCH`, `DELETE` | `/api/v1/e_responsaveis/:id` |

## 5. Estrutura organizacional e funcionario

Uma escola recem-criada ja recebe setores padrao. Para atribuir acesso a um funcionario, a cadeia e:

```text
Perfil de acesso <- Funcao <- Setor-Funcao <- Funcionario
```

Cadastre ou consulte primeiro:

| Ordem | Endpoint | Finalidade |
| --- | --- | --- |
| 1 | `GET /api/v1/u_perfis` | Perfis como `PROFESSOR`, `SECRETARIA` e `FINANCEIRO`. |
| 2 | `GET`/`POST /api/v1/r_funcoes` | Funcao e seus perfis (`r_funcoes_perfis_attributes`). |
| 3 | `GET /api/v1/r_setores` | Setores da unidade; em escola, ja sao criados no cadastro. |
| 4 | `GET`/`POST /api/v1/r_setores_funcoes` | Liga funcao a setor. |
| 5 | `GET /api/v1/r_tipos_vinculos` | Tipo do vinculo trabalhista. |
| 6 | `GET /api/v1/r_especialidades` | Especialidades opcionais. |

### Criar funcionario

`POST /api/v1/r_funcionarios`

```json
{
  "r_funcionario": {
    "r_tipo_vinculo_id": 1,
    "matricula": "FUNC-2026-001",
    "data_inicio": "2026-09-02",
    "ativo": true,
    "g_pessoa_attributes": {
      "nome": "Pedro Professor",
      "cpf": "32165498700",
      "g_sexo_id": 1,
      "email": "pedro@example.test"
    },
    "r_funcionarios_especialidades_attributes": [
      { "r_especialidade_id": 2, "principal": true, "data_inicio": "2026-09-02", "ativo": true }
    ],
    "r_funcionarios_setores_funcoes_attributes": [
      { "r_setor_funcao_id": 15, "principal": true, "data_inicio": "2026-09-02", "ativo": true }
    ]
  }
}
```

O servidor aplica a unidade do cabecalho. Para cada funcao ativa ligada ao funcionario pelo `r_setor_funcao_id`, ele encontra os perfis ativos da funcao e provisiona usuario/perfil para a pessoa. Se nao houver funcao/perfil, o funcionario e criado sem usuario. Um usuario novo precisa de e-mail.

Regras: matricula unica por unidade, uma pessoa ativa por funcionario, no maximo uma especialidade principal ativa e um vinculo setor-funcao principal ativo.

| Metodo | URL |
| --- | --- |
| `GET`, `POST` | `/api/v1/r_funcionarios` |
| `GET`, `PATCH`, `DELETE` | `/api/v1/r_funcionarios/:id` |
| `GET`, `POST` | `/api/v1/r_setores` |
| `GET`, `PATCH`, `DELETE` | `/api/v1/r_setores/:id` |
| `GET`, `POST` | `/api/v1/r_setores_funcoes` |
| `GET`, `PATCH`, `DELETE` | `/api/v1/r_setores_funcoes/:id` |

## 6. Infraestrutura da unidade

Depois da unidade, a estrutura fisica segue `predio -> bloco -> ambiente`. Todos os recursos de infraestrutura sao escopados pela unidade.

| Ordem | Metodo e URL | Corpo minimo |
| --- | --- | --- |
| 1 | `POST /api/v1/i_predios` | `{ "i_predio": { "g_tipo_predio_id": 1, "g_situacao_predio_id": 1, "nome": "Sede", "ativo": true } }` |
| 2 | `POST /api/v1/i_predios/:i_predio_id/g_andares/:g_andar_id/i_blocos` | `{ "i_bloco": { "descricao": "Bloco A", "ativo": true } }` |
| 3 | `POST /api/v1/i_blocos/:i_bloco_id/i_ambientes_prediais` | `{ "i_ambiente_predial": { "g_tipo_ambiente_predial_id": 1, "descricao": "Sala 01", "capacidade": 12, "ativo": true } }` |

Os IDs do predio e andar na URL prevalecem no cadastro de bloco; o ID do bloco na URL prevalece no ambiente. O servidor valida que o pai pertence a unidade selecionada.

Leituras aninhadas:

| Metodo | URL |
| --- | --- |
| `GET` | `/api/v1/i_predios` |
| `GET` | `/api/v1/i_predios/:i_predio_id/g_andares` |
| `GET` | `/api/v1/i_predios/:i_predio_id/g_andares/:g_andar_id/i_blocos` |
| `GET` | `/api/v1/i_blocos/:i_bloco_id/i_ambientes_prediais` |

## 7. Catalogo de referenciais e proximos modulos

Os recursos abaixo seguem o CRUD REST padrao: `GET /recurso`, `GET /recurso/:id`, `POST /recurso`, `PATCH /recurso/:id`, `DELETE /recurso/:id`. O corpo sempre usa a chave singular do recurso, por exemplo `{ "g_sexo": { "descricao": "..." } }`.

| Recurso | URL | Campos de criacao/edicao |
| --- | --- | --- |
| Sexo | `/g_sexos` | `descricao` |
| Pais | `/g_paises` | `descricao`, `sigla`, `codigo_iso` |
| Cidade | `/g_cidades` | `g_estado_id`, `descricao`, `codigo_ibge` |
| Bairro | `/g_bairros` | `g_cidade_id`, `descricao`, `codigo_ibge` |
| Parentesco | `/g_parentescos` | `descricao`, `permite_outro` |
| Alergia | `/g_alergias` | `descricao`, `ativo` |
| Necessidade especifica | `/g_necessidades_especificas` | `descricao`, `ativo` |
| Tipo de vinculo | `/r_tipos_vinculos` | `descricao`, `codigo`, `ativo` |
| Especialidade | `/r_especialidades` | `descricao`, `codigo`, `ativo` |
| Funcao | `/r_funcoes` | `descricao`, `codigo`, `ativo`, `r_funcoes_perfis_attributes` |
| Perfil | `/u_perfis` | `descricao`, `codigo`, `ativo` |
| Vinculo usuario-perfil | `/users_perfis` | `user_id`, `u_perfil_id`, `g_unidade_gestora_id`, `ativo` |
| Tipo predio | `/g_tipos_predios` | `descricao` |
| Situacao predio | `/g_situacoes_predios` | `descricao` |
| Tipo ambiente | `/g_tipos_ambientes_prediais` | `descricao` |
| Andar | `/g_andares` | `descricao`, `ordem` |

O que ainda nao aparece no dominio atual: nao ha endpoints de matricula, turma, curso, agenda/aulas, frequencia, financeiro ou avaliacao. O codigo hoje vai ate o cadastro base de unidade, pessoas, papeis, acesso, saude e infraestrutura. Esses modulos precisarao de modelagem e rotas novas quando entrarem no escopo.

## Codigos de resposta e pontos de atencao

| Status | Quando ocorre |
| --- | --- |
| `200` | Leitura, atualizacao, login e refresh bem-sucedidos. |
| `201` | Criacao bem-sucedida. |
| `204` | Soft delete ou logout bem-sucedido. |
| `400` | JSON ou query string invalida; pagina fora do intervalo. |
| `401` | Token ausente/invalido/expirado ou credenciais invalidas. |
| `403` | Usuario bloqueado, perfil sem permissao ou unidade fora do escopo. |
| `404` | Registro inexistente ou fora do escopo consultado. |
| `422` | Envelope obrigatorio ausente, validacao, regra de negocio ou unidade nao selecionada. |
| `500` | Erro nao tratado; o corpo atualmente inclui a mensagem tecnica. |

Pontos práticos para o frontend:

- Sempre chame `meu_usuario` apos o login e guarde a unidade selecionada.
- Nao trate `GPessoa` como exclusiva de uma unidade: reutilize CPF/ID antes de criar outra pessoa.
- Para campos aninhados, atualize usando o `id` retornado; use `_destroy: true` para remover itens aceitos pelo endpoint.
- Cadastros que geram usuario dependem de e-mail. Sem ele, a transacao inteira e cancelada.
- Exclusoes usam soft delete, mas podem falhar se houver dependencias configuradas com restricao.
- `GET /g_pessoas` ainda nao respeita tenant; evite usá-lo como busca ampla no frontend ate que o escopo/autorizacao seja endurecido.

## Exemplo de sequencia com curl

```bash
# 1. Autenticar
curl -X POST http://localhost:3000/api/v1/login \
  -H 'Content-Type: application/json' \
  -d '{"login":"admin@example.test","password":"senha"}'

# 2. Descobrir unidades/perfis disponiveis
curl http://localhost:3000/api/v1/meu_usuario \
  -H 'Authorization: Bearer <access_token>'

# 3. No contexto da unidade 7, consultar referenciais e criar estudante
curl 'http://localhost:3000/api/v1/g_parentescos?per_page=100' \
  -H 'Authorization: Bearer <access_token>' \
  -H 'X-Unidade-Gestora-Id: 7'

curl -X POST http://localhost:3000/api/v1/e_estudantes \
  -H 'Authorization: Bearer <access_token>' \
  -H 'X-Unidade-Gestora-Id: 7' \
  -H 'Content-Type: application/json' \
  -d '{"e_estudante":{"registro_aluno":"ALU-2026-0001","g_pessoa_attributes":{"nome":"Lucas Almeida","cpf":"11122233344","email":"lucas@example.test"}}}'
```

## Fontes do comportamento

Esta referencia foi derivada de `config/routes.rb`, controllers em `app/controllers/api/v1`, regras de escopo em `app/controllers/concerns/tenant_scoped.rb`, services em `app/services` e testes de fluxo de estudante/funcionario. Ela representa o codigo atual, inclusive a transicao ja presente de funcionario para o vinculo `setor-funcao`.
