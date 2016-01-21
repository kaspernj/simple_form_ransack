class SimpleFormRansack::FormProxy
  def self.predicates_regex
    unless @predicates_regex
      predicates = Ransack::Configuration
        .predicates
        .map(&:first)
        .map { |predicate| Regexp.escape(predicate) }
        .join("|")

      @predicates_regex = /^(.+)_(#{predicates})$/
    end

    @predicates_regex
  end

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

    match = name.to_s.match(SimpleFormRansack::FormProxy.predicates_regex)
    if match
      attribute_name = match[1]
      match_type = match[2]
    end

    as = as_from_opts(attribute_name || name.to_s, opts)
    input_html = opts.delete(:input_html) || {}
    set_value(as, name, opts, input_html)
    set_name(as, name, input_html)
    set_label(attribute_name, opts, as, match_type) if attribute_name

    opts[:required] = false unless opts.key?(:required)
    opts[:input_html] = input_html
    args << opts
    @form.input(attribute_name || name, *args)
  end

  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end

private

  def set_label(attribute_name, opts, as, match_type)
    return if opts.key?(:label)

    label_parts = []

    attribute_name.split(/_(or|and)_/).each do |attribute_name_part|
      if attribute_name_part == "and" || attribute_name_part == "or"
        label_parts << ", " unless label_parts.empty?
        next
      end

      attribute_inspector = ::SimpleFormRansack::AttributeInspector.new(
        name: attribute_name_part,
        instance: @object,
        clazz: @class,
        as: as
      )

      if attribute_inspector.generated_label?
        label = attribute_inspector.generated_label
      else
        label = @class.human_attribute_name(attribute_name_part)
      end

      if label
        label[0] = label[0].downcase if label_parts.any?
        label_parts << label
      end
    end

    if label_parts.any?
      opts[:label] = label_parts.join

      if match_type == "cont"
        opts[:label] << " #{I18n.t("simple_form_ransack.match_types.contains")}"
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

    "string"
  end
end
