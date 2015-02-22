class Comment < ActiveRecord::Base
  # Extensions
  acts_as_nested_set scope: [:link_id]

  # Configuration
  default_scope { includes(:user) }

  # Associations
  belongs_to :link, inverse_of: :comments, counter_cache: true
  belongs_to :user, inverse_of: :comments

  # Validations
  validates :body, presence: true
  validates :user, presence: true
end
