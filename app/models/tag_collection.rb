class TagCollection < ActiveRecord::Base
  # Extensions
  acts_as_taggable

  # Associations
  has_and_belongs_to_many :users
end
