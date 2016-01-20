# Inpect the model namespace for labels based on Ransack-names in order to generate labels for inputs.
class SimpleFormRansack::AttributeInspector
  def initialize(args)
    @args = args
    @ransack_name = args[:name]
    @name_parts = @ransack_name.to_s.split("_")
    @instance = args[:instance]
    @clazz = args[:clazz]
    @debug = args[:debug]

    @generated_name_classes = []
    @models = []
    @current_clazz = @clazz
    @name_builtup = []

    has_attribute_directly = @clazz.attribute_names.select { |name| name.to_s == @ransack_name.to_s }.any?

    research unless has_attribute_directly
  end

  # Loop through the name parts and inspectors reflections with it.
  def research
    @name_parts.each_with_index do |name_part, index|
      @name_builtup << name_part

      # The last part should be the attribute name.
      if index == @name_parts.length - 1
        attribute_result = attribute_by_builtup

        if attribute_result
          puts "Attribute was: #{attribute_result.fetch(:name)}" if @debug
          @attribute = attribute_result.fetch(:name)
          break
        else
          puts "Not found: #{@name_builtup.join("_")}" if @debug
          next
        end
      end

      # Try next - maybe next key need to be added? (which is common!)
      reflection_result = reflection_by_builtup
      next unless reflection_result

      @name_builtup = []
      name = reflection_result.fetch(:name)
      reflection = reflection_result.fetch(:reflection)

      puts "Name: #{name}" if @debug
      puts "Reflection: #{reflection}" if @debug

      @current_clazz = reflection.klass
      @generated_name_classes << {clazz: @current_clazz, reflection: reflection}
    end
  end

  # Returns true if a complicated label could be generated and simple form should not do this itself.
  def generated_label?
    return true if @attribute && @generated_name_classes.any?
    false
  end

  # Generates the complicated label and returns it.
  def generated_label
    name = ""

    if @generated_name_classes.last
      clazz = @generated_name_classes.last.fetch(:clazz)
      reflection = @generated_name_classes.last.fetch(:reflection)

      if reflection.collection?
        name << clazz.model_name.human(count: 2)
      else
        name << clazz.model_name.human
      end
    end

    name << " " unless name.empty?
    name << @current_clazz.human_attribute_name(@attribute).to_s.downcase

    name
  end

private

  def reflection_by_builtup
    total_name = @name_builtup.join("_")
    result = @current_clazz.reflections.find { |name, _reflection| name.to_s == total_name }
    return {name: result[0], reflection: result[1]} if result
    false
  end

  def attribute_by_builtup
    total_name = @name_builtup.join("_")
    result = @current_clazz.attribute_names.find { |name| name.to_s == total_name }
    return {name: result} if result
    false
  end
end
