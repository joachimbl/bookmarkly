class Like < ActiveRecord::Base
  # Associations
  belongs_to :user, inverse_of: :likes
  belongs_to :link, inverse_of: :likes, counter_cache: true

  # Validations
  validates :link, uniqueness: { scope: :user_id }
end
