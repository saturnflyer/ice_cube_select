# Ice Cube Select

[![QLTY](https://qlty.sh/github/gh/ice_cube_select.png)](https://qlty.sh/gh/saturnflyer/ice_cube_select)

This gem adds selectors and helpers for working with recurring schedules in a Rails app. It uses [ice_cube](https://github.com/seejohnrun/ice_cube) recurring scheduling gem.

Check out the demo code in [spec/dummy](https://github.com/saturnflyer/ice_cube_select/tree/master/spec/dummy)folder

## Requirements

- Ruby 3.3+
- Rails 8.0+
- [ice_cube](https://github.com/seejohnrun/ice_cube) 0.16+

No jQuery or other JavaScript framework dependencies. Uses vanilla JavaScript.

## Usage

Add the gem to your Gemfile:

```ruby
gem 'ice_cube-select'
```

Then install the assets:

```bash
bundle install
rails generate ice_cube_select:install
```

This copies the CSS and JavaScript files to your `app/assets` directory for use with Propshaft (Rails 8 default asset pipeline).

### Assets

Include the stylesheet and JavaScript in your layout:

```erb
<%= stylesheet_link_tag "ice_cube_select" %>
<%= javascript_include_tag "ice_cube_select" %>
<%= javascript_include_tag "ice_cube_select_dialog" %>
```

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

Ice Cube Select is I18n aware.

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

For JavaScript translations, include the locale file after the main scripts. French and English are supported:

```erb
<%= javascript_include_tag "ice_cube_select/fr" %>
```

## Testing and Development

Start the dummy server for clicking around the interface:

```console
cd spec/dummy
rails s
```

Run specs with:

```console
bundle exec rspec
```

Feel free to open issues or send pull requests.

This project is managed with [Reissue](https://github.com/SOFware/reissue).

To release a new version, make your changes and be sure to update the CHANGELOG.md.

To release a new version:

    bundle exec rake build:checksum
    bundle exec rake release

## Licensing

This project rocks and uses MIT-LICENSE.

Based on https://github.com/gregschmit/recurring_select
