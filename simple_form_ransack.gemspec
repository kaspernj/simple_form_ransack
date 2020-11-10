$LOAD_PATH.push File.expand_path("lib", __dir__)

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

  s.add_development_dependency "capybara"
  s.add_development_dependency "country_select"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "forgery"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "simple_form"
  s.add_development_dependency "sqlite3"
end
