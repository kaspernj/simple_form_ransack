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

    search_key = ransack.context.search_key

    simple_form_for(sample_model, *args) do |form|
      form_proxy = SimpleFormRansack::FormProxy.new(
        ransack: ransack,
        form: form,
        params: params[search_key] || {}
      )

      yield form_proxy
    end
  end
end
