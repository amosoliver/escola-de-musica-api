# frozen_string_literal: true

class PopulateGNecessidadesEspecificas < ActiveRecord::Migration[8.1]
  def up
    Importacao::Referenciais.populate_necessidades_especificas
  end

  def down
    GNecessidadeEspecifica.delete_all
  end
end
