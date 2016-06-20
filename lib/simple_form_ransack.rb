module SimpleFormRansack
  autoload :AttributeInspector, "simple_form_ransack/attribute_inspector"
  autoload :InputManipulator, "simple_form_ransack/input_manipulator"
  autoload :FormProxy, "simple_form_ransack/form_proxy"

  def self.locale_files
    files = []

    available_locales = []
    available_locales += I18n.available_locales if I18n.available_locales
    available_locales += Rails.application.config.i18n.available_locales if Rails.application.config.i18n.available_locales
    available_locales.uniq!

    available_locales.each do |locale|
      path = "#{File.realpath("#{File.dirname(__FILE__)}/../config/locales")}/#{locale}.yml"
      files << File.realpath(path) if File.exist?(path)
    end

    files
  end
end

require_relative "../app/helpers/simple_form_ransack_helper"
require_relative "simple_form_ransack/ransack_search_monkey_patch"
