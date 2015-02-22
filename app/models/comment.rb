class Comment < ActiveRecord::Base
  # Extensions
  acts_as_nested_set scope: [:link_id]

  # Associations
  belongs_to :link
  belongs_to :user

  # Validations
  validates :body, presence: true
  validates :user, presence: true
end
