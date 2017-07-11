class InstagramPost < ApplicationRecord
  has_paper_trail

  belongs_to :hotel
end
