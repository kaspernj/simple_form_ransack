module SimpleFormRansackHelper
  def simple_search_form_for(ransack, *args)
    if args.last.is_a?(Hash)
      opts = args.pop
    else
      opts = {}
    end

    opts[:url] = request.original_fullpath unless opts[:url]
    opts[:method] = "get" unless opts[:method]
    args << opts

    model_class = ransack.klass
    sample_model = model_class.new
    ransack_params = ransack.instance_variable_get(:@_registered_params)

    simple_form_for(sample_model, *args) do |form|
      form_proxy = SimpleFormRansack::FormProxy.new(
        ransack:,
        form:,
        params: ransack_params
      )

      yield form_proxy
    end
  end

  def simple_search_fields_for(ransack, *args)
    if args.last.is_a?(Hash)
      opts = args.pop
    else
      opts = {}
    end

    opts[:url] = request.original_fullpath unless opts[:url]
    opts[:method] = "get" unless opts[:method]
    args << opts

    model_class = ransack.klass
    sample_model = model_class.new
    ransack_params = ransack.instance_variable_get(:@_registered_params)

    simple_fields_for(sample_model, *args) do |form|
      form_proxy = SimpleFormRansack::FormProxy.new(
        ransack:,
        form:,
        params: ransack_params
      )

      yield form_proxy
    end
  end
end
