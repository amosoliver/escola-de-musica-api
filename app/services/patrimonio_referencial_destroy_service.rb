# frozen_string_literal: true

class PatrimonioReferencialDestroyService
  def initialize(record:, resource_name:)
    @record = record
    @resource_name = resource_name
  end

  def call
    return Result.success(nil, HttpStatus::NO_CONTENT, "#{resource_name} removido com sucesso") if record.destroy

    Result.failure(record.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover #{resource_name.downcase}")
  end

  private

  attr_reader :record, :resource_name
end
