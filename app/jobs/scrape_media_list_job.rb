class ScrapeMediaListJob < ApplicationJob
  queue_as :default

  def perform(args={})
    ScrapeMediaList.new(args).perform
  end
end
