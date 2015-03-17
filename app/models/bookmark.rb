class Bookmark < ActiveRecord::Base
  # Association
  belongs_to :user
  belongs_to :link
end
