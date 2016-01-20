class SimpleFormRansack::FormProxy
  def initialize(args)
    @resource = args.fetch(:resource)
    @object = @resource.object
    @class = @resource.klass
    @params = args.fetch(:params)
    @form = args.fetch(:form)

    raise "No params given in arguments: #{args.keys}" unless @params
  end

  def input(name, *args)
    if args.last.is_a?(Hash)
      opts = args.pop
    else
      opts = {}
    end

    attribute_name = real_name(name, opts)
    as = as_from_opts(attribute_name, opts)
    input_html = opts.delete(:input_html) || {}
    set_value(as, name, opts, input_html)
    set_name(as, name, input_html)
    set_label(attribute_name, opts, input_html)

    opts[:required] = false unless opts.key?(:required)
    opts[:input_html] = input_html
    args << opts
    @form.input(attribute_name, *args)
  end

  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end

private

  def set_label(attribute_name, opts, _input_html)
    unless opts.key?(:label)
      attribute_inspector = ::SimpleFormRansack::AttributeInspector.new(
        name: attribute_name,
        instance: @object,
        clazz: @class
      )

      if attribute_inspector.generated_label?
        opts[:label] = attribute_inspector.generated_label
      end
    end
  end

  def set_name(as, name, input_html)
    return if input_html.key?(:name)

    input_html[:name] = "q[#{name}]"
    input_html[:name] << "[]" if as == "check_boxes"
  end

  def set_value(as, name, opts, input_html)
    if as == "select"
      unless opts.key?(:selected)
        if @params[name]
          opts[:selected] = @params[name]
        else
          opts[:selected] = ""
        end
      end
    elsif as == "check_boxes" || as == "radio_buttons"
      unless opts.key?(:checked)
        if @params[name]
          opts[:checked] = @params[name]
        else
          opts[:checked] = ""
        end
      end
    elsif as == "boolean"
      unless input_html.key?(:checked)
        input_html[:checked] = ("checked" if @params[name] == "1")
      end
    else
      unless input_html.key?(:value)
        if @params[name]
          input_html[:value] = @params[name]
        else
          input_html[:value] = ""
        end
      end
    end
  end

  def as_list?(opts)
    return true if as_from_opts(opts) == "select"
    false
  end

  def as_from_opts(attribute_name, opts)
    if opts[:as].present?
      return opts.fetch(:as).to_s
    elsif opts[:collection] || attribute_name.end_with?("country")
      return "select"
    end

    column = @class.columns_hash[attribute_name]
    return "boolean" if column && column.type == :boolean

    "text"
  end

  def real_name(name, _opts)
    match = name.to_s.match(/^(.+)_(eq|cont|eq_any|gteq|lteq|gt|lt|start|end)$/)
    return match[1] if match
    raise "Couldn't figure out attribute name from: #{name}"
  end
end
