# frozen_string_literal: true

require "rake"

class PopulateRSetores < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    say_with_time("Populando r_setores") do
      invoke_task("r_setores:populate")
    end
  end

  def down; end

  private

  def invoke_task(task_name)
    Rails.application.load_tasks unless Rake::Task.task_defined?(task_name)
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end
end
