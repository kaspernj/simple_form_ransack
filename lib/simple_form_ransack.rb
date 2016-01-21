module SimpleFormRansack
  autoload :AttributeInspector, "simple_form_ransack/attribute_inspector"
  autoload :FormProxy, "simple_form_ransack/form_proxy"

  def self.locale_files
    files = []

    I18n.available_locales.each do |locale|
      path = "#{File.realpath("#{File.dirname(__FILE__)}/../config/locales")}/#{locale}.yml"
      files << File.realpath(path) if File.exist?(path)
    end

    files
  end
end

require_relative "../app/helpers/simple_form_ransack_helper"
