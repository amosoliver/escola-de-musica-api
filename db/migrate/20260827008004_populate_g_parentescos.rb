# frozen_string_literal: true

class PopulateGParentescos < ActiveRecord::Migration[8.1]
  def up
    Importacao::Referenciais.populate_parentescos
  end

  def down
    GParentesco.delete_all
  end
end
