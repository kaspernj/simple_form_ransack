module SimpleFormRansackHelper
  def simple_search_form_for(resource, params, *args)
    if args.last.is_a?(Hash)
      opts = args.pop
    else
      opts = {}
    end

    opts[:url] = request.original_fullpath unless opts[:url]
    opts[:method] = "get" unless opts[:method]
    args << opts

    model_class = resource.klass
    sample_model = model_class.new

    simple_form_for(sample_model, *args) do |form|
      form_proxy = SimpleFormRansack::FormProxy.new(
        resource: resource,
        form: form,
        params: params,
      )

      yield form_proxy
    end
  end
end
