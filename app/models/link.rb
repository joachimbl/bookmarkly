class Link < ActiveRecord::Base
  # Extensions
  acts_as_taggable

  # Associations
  has_and_belongs_to_many :users, uniq: true
  has_many :likes, inverse_of: :link
  has_many :comments

  # Validations
  validates :url, presence: true, uniqueness: true, url: true
  validates :users, presence: true

  # Callbacks
  before_create :fetch_from_embedly

  # Attributes
  enum media_type: [:other, :photo, :video, :rich]

  # Instance Methods
  def liked_by?(user)
    likes.exists?(user_id: user)
  end

  def fetch_from_embedly
    response = embedly_api.extract(url: url).first

    self.title = response.title
    self.description = response.description
    self.favicon_url = response.favicon_url
    self.provider_name = response.provider_name
    self.provider_url = response.provider_url
    self.media_type = response.media.type
    self.html = response.media.html if %w(video rich).include?(media_type)
    self.thumbnail_url = response.images.first['url'] if response.images.any?
  end

  def unique?
    !self.class.exists?(url: url)
  end

  def merge_with_existing
    existing_link = self.class.where(url: url).first
    users.each do |user|
      existing_link.users << user unless existing_link.users.include?(user)
    end

    return existing_link
  end

  private

  def embedly_api
    @embedly_api ||= if Rails.application.secrets.embedly_api_key
      Embedly::API.new(key: Rails.application.secrets.embedly_api_key)
    else
      Embedly::API.new
    end
  end
end
