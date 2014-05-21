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
    input_html[:name] = "q[#{name}]" unless input_html.key?(:name)
    
    if as == "select"
      opts[:selected] = @params[name] if !input_html.key?(:selected) && @params[name]
    else
      input_html[:value] = @params[name] if !input_html.key?(:value) && @params[name]
    end
    
    opts[:input_html] = input_html
    opts[:required] = false unless opts.key?(:required)
    
    args << opts
    return @form.input(attribute_name, *args)
  end
  
  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end
  
private
  
  def as_from_opts(opts)
    if opts[:as].present?
      return opts[:as].to_s
    elsif opts[:collection]
      return "select"
    end
    
    return "text"
  end
  
  def real_name(name, opts)
    match = name.to_s.match(/^(.+)_(eq|cont|eq_any)$/)
    if match
      return match[1]
    else
      raise "Couldn't figure out attribute name from: #{name}"
    end
  end
end
