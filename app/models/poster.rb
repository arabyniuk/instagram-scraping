class Poster < ApplicationRecord
  has_paper_trail

  has_many :instagram_posts
end
