require 'capybara/poltergeist'

options = {
  timeout: 120
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
