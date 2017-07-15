class ScrapeMediaListJob < ApplicationJob
  queue_as :default

  def perform(args={})
    puts args
    puts '-----'
    return if args.values.any?(&:blank?)
    ScrapeMediaList.new(args).perform
  end
end
