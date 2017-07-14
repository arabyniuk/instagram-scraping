class ScrapePosterInfoJob < ApplicationJob
  queue_as :default

  def perform(args={})
    ScrapePosterInfo.new(args).perform
  end
end
