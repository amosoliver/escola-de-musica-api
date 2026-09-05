# frozen_string_literal: true

class AddGInstrumentoToPPatrimonios < ActiveRecord::Migration[8.1]
  def change
    add_reference :p_patrimonios,
                  :g_instrumento,
                  foreign_key: { to_table: :g_instrumentos }
  end
end
