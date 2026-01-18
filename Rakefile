#!/usr/bin/env rake
require "rubygems"
require "bundler/setup"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

begin
  require "standard/rake"
rescue LoadError
  # standard not available
end

task default: :spec

require "rubygems/package_task"
Bundler::GemHelper.install_tasks

require "rdoc/task"
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "IceCubeSelect"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

require "reissue/gem"

Reissue::Task.create :reissue do |task|
  task.version_file = "lib/ice_cube_select/version.rb"
  task.fragment = :git
end
