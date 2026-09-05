# frozen_string_literal: true

class AddGTipoPatrimonioToPPatrimonios < ActiveRecord::Migration[8.1]
  def change
    add_reference :p_patrimonios,
                  :g_tipo_patrimonio,
                  foreign_key: { to_table: :g_tipos_patrimonios }
  end
end
