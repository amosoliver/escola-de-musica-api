# frozen_string_literal: true

require "rake"

class PopulateGeographicReferenceData < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    say_with_time("Executando importação de países, estados, municípios e cidades") do
      Rails.application.load_tasks unless Rake::Task.task_defined?("g_cidades:populate")
      Rake::Task["g_cidades:populate"].reenable
      Rake::Task["g_cidades:populate"].invoke
    end
  end

  def down; end
end
