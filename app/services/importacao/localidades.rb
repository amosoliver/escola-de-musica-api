# frozen_string_literal: true

require "json"
require "net/http"

module Importacao
  module Localidades
    extend self

    IBGE_BASE_URL = "https://servicodados.ibge.gov.br/api/v1/localidades".freeze
    OVERPASS_URL = "https://overpass-api.de/api/interpreter".freeze
    OVERPASS_RETRYABLE_STATUS = %w[429 502 503 504].freeze
    BRAZIL_UFS = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO].freeze
    TASK_USER = "task:localidades".freeze

    class OverpassIndisponivel < StandardError; end

    def populate_all
      log_header("Importacao de localidades iniciada")

      summaries = []
      summaries << log_step("Paises") { populate_paises }
      summaries << log_step("Estados") { populate_estados }
      summaries << log_step("Cidades") { populate_cidades }
      summaries << log_step("Bairros") { populate_bairros }

      log_header("Resumo final")
      summaries.each { |summary| log_summary(summary[:label], summary) }
      summaries
    end

    def populate_paises
      payloads = fetch_json("/paises?orderBy=nome")
      now = Time.current
      existing_by_key = GPais.with_deleted.index_by { |pais| pais.codigo_iso.presence || pais.descricao }

      inserts = []
      updates = 0
      skipped = 0

      payloads.each do |payload|
        nome = nome_pais(payload)
        next if nome.blank?

        codigo_iso = codigo_iso_pais(payload).presence
        sigla = sigla_pais(payload)
        key = codigo_iso || nome
        existing = existing_by_key[key]

        if existing
          changed = assign_if_changed(existing, descricao: nome, sigla:, codigo_iso:, updated_by: TASK_USER)
          restore_if_deleted(existing)
          changed ||= existing.changed?

          if changed
            existing.save!
            updates += 1
          else
            skipped += 1
          end
        else
          inserts << {
            descricao: nome,
            sigla:,
            codigo_iso:,
            created_by: TASK_USER,
            updated_by: TASK_USER,
            created_at: now,
            updated_at: now
          }
        end
      end

      GPais.insert_all(inserts) if inserts.any?
      build_summary(label: "Paises", fetched: payloads.size, inserted: inserts.size, updated: updates, skipped:)
    end

    def populate_estados
      brasil = brasil!
      payloads = fetch_json("/estados?orderBy=nome")
      now = Time.current
      existing_by_codigo = GEstado.with_deleted.index_by(&:codigo_ibge)

      inserts = []
      updates = 0
      skipped = 0

      payloads.each do |payload|
        codigo_ibge = payload["id"].to_s
        existing = existing_by_codigo[codigo_ibge]

        if existing
          changed = assign_if_changed(
            existing,
            descricao: payload["nome"],
            uf: payload["sigla"],
            g_pais_id: brasil.id,
            updated_by: TASK_USER
          )
          restore_if_deleted(existing)
          changed ||= existing.changed?

          if changed
            existing.save!
            updates += 1
          else
            skipped += 1
          end
        else
          inserts << {
            descricao: payload["nome"],
            uf: payload["sigla"],
            codigo_ibge:,
            g_pais_id: brasil.id,
            created_by: TASK_USER,
            updated_by: TASK_USER,
            created_at: now,
            updated_at: now
          }
        end
      end

      GEstado.insert_all(inserts) if inserts.any?
      build_summary(label: "Estados", fetched: payloads.size, inserted: inserts.size, updated: updates, skipped:)
    end

    # Cidades sao gravadas direto a partir dos municipios do IBGE (uma consulta por
    # estado), sem tabela intermediaria: GCidade ja carrega descricao/codigo_ibge/uf.
    def populate_cidades
      brasil = brasil!
      now = Time.current
      estados = GEstado.order(:uf).pluck(:id, :uf, :codigo_ibge)
      existing_by_codigo = GCidade.with_deleted.index_by(&:codigo_ibge)

      total_fetched = 0
      total_inserted = 0
      total_updated = 0
      total_skipped = 0

      estados.each_with_index do |(estado_id, uf, codigo_ibge_estado), index|
        payloads = fetch_json("/estados/#{codigo_ibge_estado}/municipios?orderBy=nome")
        total_fetched += payloads.size
        inserts = []
        updated = 0
        skipped = 0

        payloads.each do |payload|
          codigo_ibge = payload["id"].to_s
          existing = existing_by_codigo[codigo_ibge]

          if existing
            changed = assign_if_changed(
              existing,
              descricao: payload["nome"],
              uf:,
              g_pais_id: brasil.id,
              g_estado_id: estado_id,
              updated_by: TASK_USER
            )
            restore_if_deleted(existing)
            changed ||= existing.changed?

            if changed
              existing.save!
              updated += 1
            else
              skipped += 1
            end
          else
            inserts << {
              descricao: payload["nome"],
              uf:,
              codigo_ibge:,
              g_pais_id: brasil.id,
              g_estado_id: estado_id,
              created_by: TASK_USER,
              updated_by: TASK_USER,
              created_at: now,
              updated_at: now
            }
          end
        end

        GCidade.insert_all(inserts) if inserts.any?
        total_inserted += inserts.size
        total_updated += updated
        total_skipped += skipped

        puts format(
          "  [%<current>d/%<total>d] %<uf>s cidades: buscados=%<fetched>d inseridos=%<inserted>d atualizados=%<updated>d ignorados=%<skipped>d",
          current: index + 1,
          total: estados.size,
          uf:,
          fetched: payloads.size,
          inserted: inserts.size,
          updated:,
          skipped:
        )
      end

      build_summary(label: "Cidades", fetched: total_fetched, inserted: total_inserted, updated: total_updated, skipped: total_skipped)
    end

    # Bairros nao sao uma divisao oficial do IBGE, entao a fonte e o OpenStreetMap
    # (Overpass API). Uma consulta por UF (27 no total) usa "foreach" para percorrer
    # os municipios (area["admin_level"="8"]) e buscar dentro de cada um os nos/vias
    # com place=suburb|neighbourhood, usando a propria indexacao espacial do Overpass
    # em vez de uma consulta por municipio. O casamento bairro->cidade usa a tag
    # IBGE:GEOCODIGO do municipio (mais confiavel) com fallback por nome+UF.
    def populate_bairros
      now = Time.current
      cidades_por_codigo_municipio = GCidade.where.not(codigo_ibge: nil).pluck(:codigo_ibge, :id).to_h
      cidades_por_nome_uf = GCidade.where.not(uf: nil).each_with_object({}) do |cidade, memo|
        key = bairro_match_key(cidade.descricao, cidade.uf)
        memo[key] = cidade.id if key
      end

      total_fetched = 0
      total_inserted = 0
      total_updated = 0
      total_skipped = 0
      ufs_com_falha = []

      BRAZIL_UFS.each_with_index do |uf, index|
        begin
          elementos = fetch_overpass_bairros_uf(uf)
        rescue StandardError => e
          warn "  ! falha ao buscar bairros (OSM) de #{uf}, pulando: #{e.message}"
          ufs_com_falha << uf
          next
        end

        nomes_por_cidade_id = agrupar_bairros_por_cidade(elementos, uf, cidades_por_codigo_municipio, cidades_por_nome_uf)
        fetched = nomes_por_cidade_id.values.sum(&:size)
        total_fetched += fetched

        inserts = []
        updated = 0
        skipped = 0

        nomes_por_cidade_id.each do |cidade_id, nomes|
          existing_by_descricao = GBairro.with_deleted.where(g_cidade_id: cidade_id).index_by(&:descricao)
          vistos = Set.new

          nomes.each do |nome|
            next unless vistos.add?(nome)

            existing = existing_by_descricao[nome]

            if existing
              changed = assign_if_changed(existing, descricao: nome, updated_by: TASK_USER)
              restore_if_deleted(existing)
              changed ||= existing.changed?

              if changed
                existing.save!
                updated += 1
              else
                skipped += 1
              end
            else
              inserts << {
                g_cidade_id: cidade_id,
                descricao: nome,
                created_by: TASK_USER,
                updated_by: TASK_USER,
                created_at: now,
                updated_at: now
              }
            end
          end
        end

        GBairro.insert_all(inserts) if inserts.any?
        total_inserted += inserts.size
        total_updated += updated
        total_skipped += skipped

        puts format(
          "  [%<current>d/%<total>d] %<uf>s bairros (OSM): buscados=%<fetched>d inseridos=%<inserted>d atualizados=%<updated>d ignorados=%<skipped>d",
          current: index + 1,
          total: BRAZIL_UFS.size,
          uf:,
          fetched:,
          inserted: inserts.size,
          updated:,
          skipped:
        )
      end

      if ufs_com_falha.any?
        puts "  ! UFs nao importadas (rode a task novamente para tentar so essas): #{ufs_com_falha.join(', ')}"
      end

      build_summary(label: "Bairros", fetched: total_fetched, inserted: total_inserted, updated: total_updated, skipped: total_skipped)
    end

    private

    def brasil!
      GPais.find_by!(descricao: "Brasil")
    end

    def fetch_json(path, tentativas: 5)
      uri = URI("#{IBGE_BASE_URL}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30
      http.read_timeout = 120

      response = with_retries(tentativas) { http.get(uri.request_uri) }
      raise "Erro ao buscar #{uri}: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    def with_retries(tentativas)
      tentativa = 0
      begin
        tentativa += 1
        yield
      rescue Net::OpenTimeout, Net::ReadTimeout, IO::TimeoutError, SocketError, Errno::ECONNRESET, OverpassIndisponivel => e
        raise if tentativa >= tentativas

        warn "  ! falha de rede (#{e.message}), tentativa #{tentativa}/#{tentativas}, tentando novamente..."
        sleep(2**tentativa)
        retry
      end
    end

    def fetch_overpass_bairros_uf(uf)
      query = <<~OVERPASS_QL
        [out:json][timeout:600];
        area["ISO3166-2"="BR-#{uf}"]["admin_level"="4"]->.uf;
        rel["admin_level"="8"]["boundary"="administrative"](area.uf)->.municipios;
        foreach.municipios -> .m (
          .m out tags;
          .m map_to_area -> .cityarea;
          (
            node["place"~"^(suburb|neighbourhood)$"](area.cityarea);
            way["place"~"^(suburb|neighbourhood)$"](area.cityarea);
            relation["place"~"^(suburb|neighbourhood)$"](area.cityarea);
          );
          out tags;
        );
      OVERPASS_QL

      uri = URI(OVERPASS_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.open_timeout = 30
      http.read_timeout = 650

      response = with_retries(4) do
        resp = http.post(uri.request_uri, URI.encode_www_form(data: query))
        raise OverpassIndisponivel, "Overpass respondeu #{resp.code} para #{uf}" if OVERPASS_RETRYABLE_STATUS.include?(resp.code)

        resp
      end
      raise "Erro ao buscar bairros (OSM) para #{uf}: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)["elements"] || []
    end

    # O foreach do Overpass emite, em sequencia, a tag do municipio seguida das
    # tags dos bairros contidos nele; agrupamos aqui reconstruindo essa relacao
    # a partir da ordem dos elementos retornados.
    def agrupar_bairros_por_cidade(elementos, uf, cidades_por_codigo_municipio, cidades_por_nome_uf)
      cidade_atual_id = nil
      resultado = Hash.new { |hash, key| hash[key] = [] }

      elementos.each do |elemento|
        tags = elemento["tags"] || {}

        if tags["place"] == "municipality"
          codigo_municipio = tags["IBGE:GEOCODIGO"]
          cidade_atual_id = codigo_municipio && cidades_por_codigo_municipio[codigo_municipio]
          cidade_atual_id ||= cidades_por_nome_uf[bairro_match_key(tags["name"], uf)]
        elsif cidade_atual_id && tags["name"].present?
          resultado[cidade_atual_id] << tags["name"]
        end
      end

      resultado
    end

    def bairro_match_key(nome, uf)
      return nil if nome.blank? || uf.blank?

      "#{normalize_nome(nome)}|#{uf.to_s.upcase}"
    end

    def normalize_nome(str)
      I18n.transliterate(str.to_s).downcase.strip.squeeze(" ")
    end

    def codigo_iso_pais(payload)
      identificador = payload["id"]
      return identificador["ISO-ALPHA-3"] || identificador["M49"] if identificador.is_a?(Hash)

      identificador
    end

    def sigla_pais(payload)
      identificador = payload["id"]
      return identificador["ISO-ALPHA-2"] || identificador["ISO-ALPHA-3"] if identificador.is_a?(Hash)

      nil
    end

    def nome_pais(payload)
      nome = payload["nome"]
      return nome["abreviado"] || nome["nome"] if nome.is_a?(Hash)

      nome
    end

    def restore_if_deleted(record)
      return unless record.respond_to?(:deleted_at) && record.deleted_at.present?

      record.deleted_at = nil
    end

    def assign_if_changed(record, attributes)
      changed = false

      attributes.each do |key, value|
        next if record.public_send(key) == value

        record.public_send("#{key}=", value)
        changed = true
      end

      changed
    end

    def build_summary(label:, fetched:, inserted:, updated:, skipped:)
      { label:, fetched:, inserted:, updated:, skipped: }
    end

    def log_step(label)
      puts
      puts "== #{label}"
      summary = yield
      log_summary(label, summary)
      summary
    end

    def log_summary(label, summary)
      puts format(
        "   %<label>s: buscados=%<fetched>d inseridos=%<inserted>d atualizados=%<updated>d ignorados=%<skipped>d",
        label:,
        fetched: summary[:fetched],
        inserted: summary[:inserted],
        updated: summary[:updated],
        skipped: summary[:skipped]
      )
    end

    def log_header(message)
      puts
      puts "=============================="
      puts message
      puts "=============================="
    end
  end
end
