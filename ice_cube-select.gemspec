$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ice_cube_select/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ice_cube-select"
  s.version     = IceCubeSelect::VERSION
  s.authors     = ["Jobber", "Forrest Zeisler", "Nathan Youngman"]
  s.email       = ["jim@saturnflyer.com"]
  s.homepage    = "http://github.com/saturnflyer/ice_cube_select"
  s.summary     = "A select helper which gives you magical powers to generate ice_cube rules."
  s.description = "This gem provides a useful interface for creating recurring rules for the ice_cube gem."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"] + Dir["gemfiles/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 5.2", "< 8"
  s.add_dependency "jquery-rails", ">= 3.0", "< 5"
  s.add_dependency "ice_cube", "~> 0.11"
  s.add_dependency "sass-rails", ">= 4.0", "< 7"

  s.license = 'MIT'
end
