class SimpleFormRansack::FormProxy
  def initialize(args)
    @resource = args[:resource]
    @object = @resource.object
    @class = @resource.klass
    @params = args[:params]
    @form = args[:form]
    
    raise "No params given in arguments: #{args.keys}" unless @params
  end
  
  def input(name, *args)
    if args.last.is_a?(Hash)
      opts = args.pop
    else
      opts = {}
    end
    
    attribute_name = real_name(name, opts)
    as = as_from_opts(opts)
    
    input_html = opts.delete(:input_html) || {}
    
    if as == "select"
      if !opts.key?(:selected)
        if @params[name]
          opts[:selected] = @params[name]
        else
          opts[:selected] = ""
        end
      end
    elsif as == "check_boxes"
      if !opts.key?(:checked)
        if @params[name]
          opts[:checked] = @params[name]
        else
          opts[:checked] = ""
        end
      end
    else
      if !input_html.key?(:value)
        if @params[name]
          input_html[:value] = @params[name]
        else
          input_html[:value] = ""
        end
      end
    end
    
    unless input_html.key?(:name)
      input_html[:name] = "q[#{name}]"
      input_html[:name] << "[]" if as == "check_boxes"
    end
    
    opts[:input_html] = input_html
    opts[:required] = false unless opts.key?(:required)
    
    if !opts.key?(:label)
      attribute_inspector = ::SimpleFormRansack::AttributeInspector.new(
        :name => attribute_name,
        :instance => @object,
        :clazz => @class
      )
      if attribute_inspector.generated_label?
        opts[:label] = attribute_inspector.generated_label
      end
    end
    
    args << opts
    return @form.input(attribute_name, *args)
  end
  
  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end
  
private
  
  def as_list?(opts)
    if as_from_opts(opts) == "select"
      return true
    else
      return false
    end
  end
  
  def as_from_opts(opts)
    if opts[:as].present?
      return opts[:as].to_s
    elsif opts[:collection]
      return "select"
    end
    
    return "text"
  end
  
  def real_name(name, opts)
    match = name.to_s.match(/^(.+)_(eq|cont|eq_any|gteq|lteq|gt|lt)$/)
    if match
      return match[1]
    else
      raise "Couldn't figure out attribute name from: #{name}"
    end
  end
end
