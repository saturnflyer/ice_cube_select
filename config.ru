ENV["BUNDLE_GEMFILE"] ||= File.expand_path("spec/dummy/Gemfile", __dir__)
require "bundler/setup"
require ::File.expand_path("spec/dummy/config/environment", __dir__)

run Rails.application
Rails.application.load_server
