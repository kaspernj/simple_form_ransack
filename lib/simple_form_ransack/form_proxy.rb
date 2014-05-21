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
    
    match = name.to_s.match(/^(.+)_(eq|cont|eq_any)$/)
    if match
      attribute_name = match[1]
    else
      raise "Couldn't figure out attribute name from: #{name}"
    end
    
    input_html = opts.delete(:input_html) || {}
    input_html[:name] = "q[#{name}]" unless input_html.key?(:name)
    input_html[:value] = @params[name] if !input_html.key?(:value) && @params[name]
    
    opts[:input_html] = input_html
    opts[:required] = false unless opts.key?(:required)
    
    args << opts
    return @form.input(attribute_name, *args)
  end
  
  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end
end
