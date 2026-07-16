$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ice_cube_select/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "ice_cube-select"
  s.version = IceCubeSelect::VERSION
  s.authors = ["Jim Gay", "Jobber", "Forrest Zeisler", "Nathan Youngman"]
  s.email = ["jim@saturnflyer.com"]
  s.homepage = "http://github.com/saturnflyer/ice_cube_select"
  s.summary = "A select helper which gives you magical powers to generate ice_cube rules."
  s.description = "This gem provides a useful interface for creating recurring rules for the ice_cube gem."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"] + Dir["gemfiles/*"]

  s.add_dependency "rails", ">= 8.0"
  s.add_dependency "ice_cube", ">= 0.17"

  s.license = "MIT"

  s.post_install_message = <<~MSG
    ice_cube_select installed successfully!

    The assets are served automatically from the engine (Propshaft and
    Sprockets both pick them up). Just reference them in your layout:

      <%= stylesheet_link_tag "ice_cube_select" %>
      <%= javascript_include_tag "ice_cube_select" %>
      <%= javascript_include_tag "ice_cube_select_dialog" %>

    Only run `rails generate ice_cube_select:install` if you want to copy the
    assets into your app to customize them.

    For more info: https://github.com/saturnflyer/ice_cube_select
  MSG
end
