class ScrapePosterInfoJob < ApplicationJob
  queue_as :default

  def perform(args={})
    puts args
    puts '-----'
    ScrapePosterInfo.new(args).perform
  end
end
