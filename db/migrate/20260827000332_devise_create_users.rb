# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.references :g_pessoa, foreign_key: true
      t.string :cpf
      t.string :refresh_token
      t.boolean :primeiro_acesso
      t.string :token_primeiro_acesso
      t.boolean :bloqueado
      t.datetime :data_bloqueio
      t.string :motivo_bloqueio
      t.datetime :data_ultimo_acesso
      t.integer :tentativas_acesso
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :cpf, unique: true
    add_index :users, :deleted_at
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
