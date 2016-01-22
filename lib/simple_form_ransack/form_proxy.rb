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
    @ransack = args.fetch(:ransack)
    @object = @ransack.object
    @class = @ransack.klass
    @params = args.fetch(:params)
    @form = args.fetch(:form)

    raise "No params given in arguments: #{args.keys}" unless @params
  end

  def input(name, *args)
    input_manipulator = SimpleFormRansack::InputManipulator.new(
      name: name,
      args: args,
      params: @params,
      class: @class
    )

    @form.input(input_manipulator.attribute_name, *args)
  end

  def method_missing(method_name, *args, &blk)
    @form.__send__(method_name, *args, &blk)
  end
end
