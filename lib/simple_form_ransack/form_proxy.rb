class SimpleFormRansack::FormProxy
  def self.predicates_regex
    unless @predicates_regex
      if Object.const_defined?(:Ransack)
        predicates = Ransack::Configuration
          .predicates
          .sorted_names_with_underscores
          .map(&:first)
          .map { |predicate| Regexp.escape(predicate) }
          .join("|")
      else
        # BazaModels support
        predicates = "cont|eq|gteq|lteq|gt|lt|eq_any"
      end

      @predicates_regex = /^(.+)_(#{predicates})$/
    end

    @predicates_regex
  end

  def initialize(args)
    @ransack = args.fetch(:ransack)
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
      search_key: @ransack.context.search_key,
      class: @class
    )

    @form.input(input_manipulator.attribute_name, *args)
  end

  def method_missing(method_name, *args, &blk) # rubocop:disable Style/MissingRespondToMissing
    @form.__send__(method_name, *args, &blk)
  end
end
