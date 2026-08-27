module ApiResponses
  extend ActiveSupport::Concern

  included do
    def render_success(data: {}, message: nil, status: :ok, blueprint: nil)
      message ||= "Operacao realizada com sucesso"
      serialized_data = serialize_data(data, blueprint: blueprint)
      render json: success_payload(message, serialized_data), status: status
    end

    def render_error(errors: [], message: nil, status: :unprocessable_entity)
      message ||= "Nao foi possivel processar a requisicao"
      render json: error_payload(message, errors), status: status
    end

    def render_no_content(message: "Operacao realizada com sucesso", status: :no_content)
      render json: { success: true, message: message }, status: status
    end

    private

    def serialize_data(data, blueprint: nil)
      return data if data.nil?
      return data if primitive_response?(data)

      blueprint ||= resolve_blueprint_for(data)
      return raw_attributes_for(data) unless blueprint

      if data.respond_to?(:to_ary)
        blueprint.render_as_hash(data)
      else
        blueprint.render_as_hash(data)
      end
    end

    def success_payload(message, data)
      {
        success: true,
        message: message,
        data: data,
        timestamp: Time.current.iso8601
      }
    end

    def error_payload(message, errors)
      {
        success: false,
        message: message,
        errors: normalize_errors(errors),
        timestamp: Time.current.iso8601
      }
    end

    def normalize_errors(errors)
      case errors
      when Hash
        errors.flat_map do |field, messages|
          Array(messages).map { |message| "#{field} #{message}" }
        end
      when String
        [errors]
      else
        Array(errors)
      end
    end

    def primitive_response?(data)
      data.is_a?(Hash) || data.is_a?(String) || data.is_a?(Numeric) || data == true || data == false
    end

    def resolve_blueprint_for(data)
      target = data.respond_to?(:to_ary) ? data.to_ary.first : data
      return if target.nil?

      "#{target.class.name}Blueprint".safe_constantize
    end

    def raw_attributes_for(data)
      return data.map { |item| raw_attributes_for(item) } if data.respond_to?(:to_ary)
      return data.attributes if data.respond_to?(:attributes)

      data
    end
  end
end
