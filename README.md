[![Code Climate](https://codeclimate.com/github/kaspernj/simple_form_ransack/badges/gpa.svg)](https://codeclimate.com/github/kaspernj/simple_form_ransack)
[![Test Coverage](https://codeclimate.com/github/kaspernj/simple_form_ransack/badges/coverage.svg)](https://codeclimate.com/github/kaspernj/simple_form_ransack)
[![Build Status](https://img.shields.io/shippable/540e7b9e3479c5ea8f9ec24f.svg)](https://app.shippable.com/projects/540e7b9e3479c5ea8f9ec24f/builds/latest)

# SimpleFormRansack

SimpleForm and Ransack combined.


# Installation

In your Gemfile:
```ruby
gem 'simple_form_ransack'
```

In your ApplicationHlper:
```ruby
module ApplicationHelper
  include SimpleFormRansackHelper
  ...
end
```

In "application.rb" (for translations):
```ruby
class Application
  config.i18n.load_path += SimpleFormRansack.locale_files
end
```

# Usage

In your controller:
```ruby
class CustomerController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    @ransack = Customer.ransack(@ransack_params)
    @customers = @ransack.result
  end
end
```

In your views:
```
<%= simple_search_form_for @ransack do |f| %>
  <%= f.input :name_cont %>
  <%= f.submit %>
<% end %>
```

The `name_cont` input field now gets it label, hint and more translated as normally for a input with `name` but functions with the input-name `q[name_cont]`, making it much easier to use Ransack and SimpleForm, because you don't have to give label, hint or anything else manually.
