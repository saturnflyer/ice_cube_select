require "capybara/rspec"
require "capybara/playwright"

Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: true)
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :playwright

Capybara.app = Rails.application

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers, type: :system

  config.before(:each, type: :system) do
    Capybara.current_driver = :rack_test
  end

  config.before(:each, type: :system, js: true) do
    Capybara.current_driver = :playwright
  end

  config.after(:each, type: :system) do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
