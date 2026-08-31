# frozen_string_literal: true

class MakeGPessoaUniqueOnUsers < ActiveRecord::Migration[8.1]
  def up
    remove_index :users, :g_pessoa_id if index_exists?(:users, :g_pessoa_id)
    add_index :users, :g_pessoa_id, unique: true, if_not_exists: true
  end

  def down
    remove_index :users, :g_pessoa_id if index_exists?(:users, :g_pessoa_id)
    add_index :users, :g_pessoa_id, if_not_exists: true
  end
end
