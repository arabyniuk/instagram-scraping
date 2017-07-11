class InstagramPost < ApplicationRecord
  has_paper_trail

  mount_uploaders :photo, PostPhotoUploader

  belongs_to :hotel
end
