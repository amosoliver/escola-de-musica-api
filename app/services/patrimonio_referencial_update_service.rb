# frozen_string_literal: true

class PatrimonioReferencialUpdateService
  def initialize(record:, params:, resource_name:)
    @record = record
    @params = params
    @resource_name = resource_name
  end

  def call
    return Result.success(record, HttpStatus::OK, "#{resource_name} atualizado com sucesso") if record.update(params)

    Result.failure(record.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel atualizar #{resource_name.downcase}")
  end

  private

  attr_reader :record, :params, :resource_name
end
