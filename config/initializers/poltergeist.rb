require 'capybara/poltergeist'

options = {
  timeout: 300
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
