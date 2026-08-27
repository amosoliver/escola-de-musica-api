# frozen_string_literal: true

require "rake"

class PopulateCeTiposDeclarante < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    say_with_time("Populando ce_tipos_declarante") do
      Rails.application.load_tasks unless Rake::Task.task_defined?("ce_tipos_declarante:populate")
      Rake::Task["ce_tipos_declarante:populate"].reenable
      Rake::Task["ce_tipos_declarante:populate"].invoke
    end
  end

  def down; end
end
