# frozen_string_literal: true

class PopulateGAlergias < ActiveRecord::Migration[8.1]
  def up
    Importacao::Referenciais.populate_alergias
  end

  def down
    GAlergia.delete_all
  end
end
