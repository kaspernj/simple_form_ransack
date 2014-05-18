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
```ruby
<%= simple_search_form_for @ransack, @ransack_params do |f| %>
  <%= f.input :name_cont %>
  <%= f.submit %>
<% end %>
```

The "name_cont" input field now gets it label, hint and more translated as normally for a input with `name` but functions with the input-name `q[name_cont]`, making it much easier to use Ransack and SimpleForm, because you don't have to give label, hint or anything else manually.
