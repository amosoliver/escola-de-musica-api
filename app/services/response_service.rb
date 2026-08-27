class ResponseService
  include Pagy::Backend

  def self.pagy_index(query_result, params, controller, blueprint: nil, before_serialize: nil)
    if query_result.empty?
      return success(
        data: { pagy: pagy_items(1, 0, 0, (params[:per_page] || 10).to_i), items: [] },
        message: "Nenhum registro encontrado"
      )
    end

    if query_result.is_a?(Array) && query_result.first.is_a?(Hash)
      return paginate_array(query_result, params)
    end

    if params[:page] || params[:per_page]
      begin
        pagy, paged = controller.send(:pagy, query_result, limit: params[:per_page] || 10)
        serializer_options = before_serialize ? before_serialize.call(paged) : {}
        success(
          data: {
            pagy: pagy_items(pagy.page, pagy.pages, pagy.count, pagy.limit),
            items: serialize_collection(paged, blueprint, serializer_options: serializer_options)
          }
        )
      rescue Pagy::OverflowError
        msg = "Pagina #{params[:page]} esta fora do intervalo de paginas."
        error(message: msg, status: :bad_request, errors: [ msg ])
      end
    else
      paged = query_result
      serializer_options = before_serialize ? before_serialize.call(paged) : {}
      total_count = query_result.length
      success(
        data: {
          pagy: pagy_items(1, 1, total_count, total_count),
          items: serialize_collection(paged, blueprint, serializer_options: serializer_options)
        }
      )
    end
  end

  def self.handle_service_result(result, blueprint: nil)
    if result.success?
      return no_content(message: result.message) if result.status.to_i == HttpStatus::NO_CONTENT

      data = serialize_resource(result.value, blueprint)
      success(data: data, message: result.message, status: result.status)
    else
      error(message: result.message, status: result.status, errors: Array(result.error).flatten)
    end
  end

  def self.handle_paginated_service_result(result, params)
    return error(message: result.message, status: result.status, errors: Array(result.error).flatten) if result.failure?

    data = result.value || {}
    items = data[:items] || []
    per_page = (params[:per_page] || 50).to_i
    page = (params[:page] || 1).to_i
    total_count = (data[:total_count] || items.size).to_i
    total_pages = total_count.zero? ? 0 : (total_count.to_f / per_page).ceil
    meta = data.except(:items, :total_count, :pagy)

    success(
      data: {
        **meta,
        pagy: pagy_items(page, total_pages, total_count, per_page),
        items: items
      },
      message: result.message,
      status: result.status || :ok
    )
  end

  def self.success(data: nil, message: "Operacao realizada com sucesso", status: :ok, blueprint: nil)
    {
      json: {
        success: true,
        message: message,
        data: serialize_resource(data, blueprint),
        timestamp: Time.current.iso8601
      },
      status: status
    }
  end

  def self.no_content(message: "Operacao realizada com sucesso")
    {
      json: {
        success: true,
        message: message,
        timestamp: Time.current.iso8601
      },
      status: :no_content
    }
  end

  def self.error(message: "Erro", status: :unprocessable_entity, errors: [])
    {
      json: {
        success: false,
        message: message,
        errors: Array(errors).flatten,
        timestamp: Time.current.iso8601
      },
      status: status
    }
  end

  def self.paginate_array(array, params)
    per_page = (params[:per_page] || 10).to_i
    page = (params[:page] || 1).to_i
    total_count = array.size
    total_pages = (total_count.to_f / per_page).ceil
    paginated_items = array.each_slice(per_page).to_a[page - 1] || []

    success(
      data: {
        pagy: pagy_items(page, total_pages, total_count, per_page),
        items: paginated_items
      }
    )
  end

  def self.pagy_items(current_page, total_pages, total_count, per_page)
    {
      current_page: current_page,
      total_pages: total_pages,
      total_count: total_count,
      per_page: per_page
    }
  end

  def self.serialize_collection(collection, blueprint, serializer_options: {})
    serialize_resource(collection, blueprint, serializer_options: serializer_options)
  end

  def self.serialize_resource(resource, blueprint, serializer_options: {})
    return resource if resource.nil?
    return resource if primitive_response?(resource)

    blueprint ||= resolve_blueprint(resource)
    return raw_attributes(resource) unless blueprint

    blueprint.render_as_hash(resource, serializer_options)
  end

  def self.resolve_blueprint(resource)
    target = resource.respond_to?(:to_ary) ? resource.to_ary.first : resource
    return if target.nil?

    "#{target.class.name}Blueprint".safe_constantize
  end

  def self.raw_attributes(resource)
    return resource.map { |item| raw_attributes(item) } if resource.respond_to?(:to_ary)
    return resource.attributes if resource.respond_to?(:attributes)

    resource
  end

  def self.primitive_response?(resource)
    resource.is_a?(Hash) || resource.is_a?(String) || resource.is_a?(Numeric) || resource == true || resource == false
  end

  private_class_method :paginate_array, :pagy_items, :serialize_collection,
                       :serialize_resource, :resolve_blueprint, :raw_attributes,
                       :primitive_response?
end
