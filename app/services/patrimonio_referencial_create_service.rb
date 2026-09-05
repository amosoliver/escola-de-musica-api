# frozen_string_literal: true

class PatrimonioReferencialCreateService
  def initialize(model:, params:, resource_name:)
    @model = model
    @params = params
    @resource_name = resource_name
  end

  def call
    record = model.new(params)
    return Result.success(record, HttpStatus::CREATED, "#{resource_name} criado com sucesso") if record.save

    Result.failure(record.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar #{resource_name.downcase}")
  end

  private

  attr_reader :model, :params, :resource_name
end
