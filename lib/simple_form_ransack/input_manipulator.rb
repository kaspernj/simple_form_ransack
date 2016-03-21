class SimpleFormRansack::InputManipulator
  attr_reader :args

  def initialize(args)
    @args = args.fetch(:args)
    @name = args.fetch(:name)
    @params = args.fetch(:params)
    @class = args.fetch(:class)

    if @args.last.is_a?(Hash)
      @opts = @args.pop
    else
      @opts = {}
    end

    @input_html = @opts[:input_html] || {}

    calculate_name
    calculate_as

    set_values
  end

  def attribute_name
    @attribute_name || @name
  end

private

  def set_values
    @opts[:required] = false unless @opts.key?(:required)
    @opts[:input_html] = @input_html
    @opts[:as] = @as # This fixes bug with delegated methods in SimpleForm - don't remove

    set_value
    set_name
    set_include_blank
    set_label if @attribute_name && !@opts.key?(:label)

    @args << @opts
  end

  def calculate_name
    match = @name.to_s.match(SimpleFormRansack::FormProxy.predicates_regex)
    return unless match

    @attribute_name = match[1]
    @match_type = match[2]

    @name_parts = @attribute_name.split(/_(or|and)_/)
    @name_parts_length = @name_parts.length
  end

  def calculate_as
    column = @class.columns_hash[@attribute_name]

    if @opts[:as].present?
      @as = @opts.fetch(:as).to_s
    elsif @opts[:collection]
      calculate_as_collection
    elsif @attribute_name.to_s.end_with?("country")
      @as = "country"
    elsif column && column.type == :boolean
      @as = "boolean"
    end

    @as ||= "string"
  end

  def calculate_as_collection
    if @match_type == "eq_any"
      @as = "check_boxes"
    else
      @as = "select"
    end
  end

  def set_name
    # This overrides the individual check boxes and messes up the label targets
    # There won't be any main input anyway, so it doesn't mess anything up either
    @input_html[:id] = "q_#{@name}" unless @as == "check_boxes"

    return if @input_html.key?(:name)

    @input_html[:name] = "q[#{@name}]"
    @input_html[:name] << "[]" if @as == "check_boxes"
  end

  def set_label
    label_parts = []

    @name_parts.each_with_index do |attribute_name_part, index|
      if attribute_name_part == "and" || attribute_name_part == "or"
        label_parts << add_between_label(index, attribute_name_part) unless label_parts.empty?
        next
      end

      label = label_part(attribute_name_part)

      if label
        label[0] = label[0].downcase if label_parts.any?
        label_parts << label
      end
    end

    label_from_parts(label_parts)
  end

  def add_between_label(index, attribute_name_part)
    if index == @name_parts_length - 2
      " #{I18n.t("simple_form_ransack.words.#{attribute_name_part}")} "
    else
      ", "
    end
  end

  def label_from_parts(label_parts)
    return if label_parts.empty?

    @opts[:label] = label_parts.join
    prepend_label_for = %w(cont gteq lteq)

    return unless prepend_label_for.include?(@match_type)
    @opts[:label] << " #{I18n.t("simple_form_ransack.match_types.#{@match_type}")}"
  end

  def label_part(attribute_name_part)
    attribute_inspector = ::SimpleFormRansack::AttributeInspector.new(
      name: attribute_name_part,
      instance: @object,
      clazz: @class,
      as: @as
    )

    if attribute_inspector.generated_label?
      attribute_inspector.generated_label
    else
      @class.human_attribute_name(attribute_name_part)
    end
  end

  def set_value
    if @as == "select" || @as == "country"
      set_value_for_select
    elsif @as == "check_boxes" || @as == "radio_buttons"
      set_value_for_checked
    elsif @as == "boolean"
      set_value_for_boolean
    else
      set_value_for_input
    end
  end

  def set_value_for_select
    return if @opts.key?(:selected)

    if @params[@name]
      @opts[:selected] = @params[@name]
    else
      @opts[:selected] = ""
    end
  end

  def set_value_for_checked
    return if @opts.key?(:checked)

    if @params[@name]
      @opts[:checked] = @params[@name]
    else
      @opts[:checked] = ""
    end
  end

  def set_value_for_boolean
    return if @input_html.key?(:checked)
    @input_html[:checked] = ("checked" if @params[@name] == "1")
  end

  def set_value_for_input
    return if @input_html.key?(:value)

    if @params[@name]
      @input_html[:value] = @params[@name]
    else
      @input_html[:value] = ""
    end
  end

  def set_include_blank
    return if @opts.key?(:include_blank)
    return if @as != "select" && @as != "country"
    @opts[:include_blank] = true
  end
end
