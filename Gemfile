source "https://rubygems.org"
gemspec

group :development do
  gem "appraisal"
  gem "capybara"
  gem "country_select"
  gem "factory_girl_rails"
  gem "forgery"

  if RUBY_VERSION.start_with?("3.")
    gem "nokogiri", "1.16.0"
  else
    gem "nokogiri", "1.15.5"
  end

  gem "pry"
  gem "rspec-rails"
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", require: false
  gem "simple_form"
  gem "sqlite3"
end
