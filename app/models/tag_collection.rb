class TagCollection < ActiveRecord::Base
  # Extensions
  acts_as_taggable

  # Associations
  has_and_belongs_to_many :users

  # Instance Methods
  def tag_list_string
    tag_list.join(',')
  end
end
