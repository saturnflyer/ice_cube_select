# Ice Cube Select

[![Code Climate](https://codeclimate.com/github/saturnflyer/ice_cube_select.png)](https://codeclimate.com/github/saturnflyer/ice_cube_select)

This gem adds selectors and helpers for working with recurring schedules in a Rails app. It uses [ice_cube](https://github.com/seejohnrun/ice_cube) recurring scheduling gem.

Check out the [live demo](http://ice-cube-select-demo.herokuapp.com/) (code in [spec/dummy](https://github.com/saturnflyer/ice_cube_select/tree/master/spec/dummy) folder)


## Usage

Basic selector:

Add the gem to your Gemfile:

```ruby
gem 'ice_cube_select'
```

### Require Assets

#### Desktop Interface:
- application.js: `//= require ice_cube_select`
- application.css: `//= require ice_cube_select`

#### jQuery Mobile Interface:
- application.js: `//= require jquery-mobile-rs`
- application.css: `//= require jquery-mobile-rs`

### Form Helper

In the form view call the helper:

```erb
<%= f.select_recurring :recurring_rule_column %>
```

#### Options

```ruby
f.select_recurring :current_existing_rule, [
  IceCube::Rule.weekly.day(:monday, :wednesday, :friday),
  IceCube::Rule.monthly.day_of_month(-1)
]
```

Use :allow_blank for a "not recurring" option:

```ruby
  f.select_recurring :current_existing_rule, nil, :allow_blank => true
```


### Additional Helpers

Ice Cube Select also comes with helpers for parsing the
parameters when they hit your application.

You can send the column into the `is_valid_rule?` method to check the
validity of the input.

```ruby
IceCubeSelect.is_valid_rule?(possible_rule)
```

There is also a `dirty_hash_to_rule` method for sanitizing the inputs
for IceCube. This is sometimes needed if you're receiving strings, fixed
numbers, strings vs symbols, etc.

```ruby
IceCubeSelect.dirty_hash_to_rule(params)
```

### I18n

Ice Cube Select is I18n aware

You can create a locale file like this:

```yaml
en:
  ice_cube_select:
    not_recurring: "- not recurring -"
    change_schedule: "Change schedule..."
    set_schedule: "Set schedule..."
    new_custom_schedule: "New custom schedule..."
    custom_schedule: "Custom schedule..."
    or: or
```

You have to translate JavaScript texts too by including the locale file in your assets manifest. Only French and English are supported for the moment.

```
//= require ice_cube_select/en
//= require ice_cube_select/fr
```

## Testing and Development

Start the dummy server for clicking around the interface:

```console
rails s
```

Use [Guard](https://github.com/guard/guard) and RSpec for all tests. I'd
love to get Jasmine running also, but haven't had time yet.

Tests can be ran against different versions of Rails like so:

```
BUNDLE_GEMFILE=gemfiles/Gemfile.rails-7.0.x bundle install
BUNDLE_GEMFILE=gemfiles/Gemfile.rails-7.0.x bundle exec rspec spec
```

Feel free to open issues or send pull requests.

## Licensing

This project rocks and uses MIT-LICENSE.

Based on https://github.com/GetJobber/recurring_select
