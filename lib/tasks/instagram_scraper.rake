namespace :instagram_scraper do
  desc "get/diff media list and poster by name, name_japanese, location"
  task media_link: :environment do
    #ScrapeMediaListJob.perform_now({location: Hotel.find(970).location_id, hotel_id: Hotel.find(174).id})
    Hotel.find_each do |hotel|
      puts "get #{hotel.name} media list"
      hotel.tag_variations.each do |variation|
        puts "get with #{variation} tag"
        ScrapeMediaListJob.perform_later({tag: variation, hotel_id: hotel.id})
      end

      puts "get with #{hotel.name_japanese} tag"
      ScrapeMediaListJob.perform_later({tag: hotel.name_japanese, hotel_id: hotel.id})
      ScrapeMediaListJob.perform_later({location: hotel.location_id, hotel_id: hotel.id})
    end
  end

  desc "check poster diff"
  task poster_info: :environment do
    Poster.find_each do |poster|
      puts "check #{poster.username} poster"
      ScrapePosterInfoJob.perform_later({username: poster.username})
    end
  end
end
