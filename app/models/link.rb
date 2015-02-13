class Link < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :users

  # Validations
  validates :url, presence: true, uniqueness: true
  validates :users, presence: true

  # Callbacks
  before_create :fetch_from_embedly

  enum media_type: [:other, :photo, :video, :rich]

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
    existing_link.users << users
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
