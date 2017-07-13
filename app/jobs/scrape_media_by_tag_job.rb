class ScrapeMediaByTagJob < ApplicationJob
  queue_as :default

  def perform(args={})
    ScrapeMediaByTag.new(args).perform
  end
end
