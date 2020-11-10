$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_form_ransack/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_form_ransack"
  s.version     = SimpleFormRansack::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://www.github.com/kaspernj/simple_form_ransack"
  s.summary     = "Ransack and SimpleForm combined."
  s.description = "Makes it easy to use SimpleForm::FormBuilder with Ransack without constantly having to supply labels and other pains."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"
  s.add_dependency "ransack", ">= 1.8.6"

  s.add_development_dependency "capybara", "3.33.0"
  s.add_development_dependency "sqlite3", "1.4.2"
  s.add_development_dependency "rspec-rails", "4.0.1"
  s.add_development_dependency "pry", "0.10.4"
  s.add_development_dependency "factory_girl_rails", "4.9.0"
  s.add_development_dependency "forgery", "0.8.1"
  s.add_development_dependency "simple_form", "4.0.0"
  s.add_development_dependency "country_select", "4.0.0"
  s.add_development_dependency "rubocop", "0.36.0"
end
