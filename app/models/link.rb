class Link < ActiveRecord::Base
  # Extensions
  acts_as_taggable

  # Configuration
  default_scope -> { includes(:bookmarks) }

  # Associations
  has_many :bookmarks
  has_many :users, -> { includes(:bookmarks).where(bookmarks: { private: false }) }, through: :bookmarks
  has_many :likes, inverse_of: :link, dependent: :destroy
  has_many :comments, inverse_of: :link, dependent: :destroy

  # Attributes
  enum media_type: [:other, :photo, :video, :rich]
  accepts_nested_attributes_for :bookmarks, update_only: true, allow_destroy: false

  # Validations
  validates :url, presence: true, uniqueness: true, url: true
  validates :users, presence: true

  # Callbacks
  before_create :fetch_from_embedly

  # Scopes
  scope :for_user, ->(user) { where(bookmarks: { user_id: user }) }
  scope :visible_for, ->(user) { joins(:bookmarks).where('bookmarks.private = \'f\' OR bookmarks.user_id = ?', user.try(:id)).uniq }

  # Instance Methods
  def liked_by?(user)
    likes.exists?(user_id: user)
  end

  def bookmark_for(user)
    bookmarks.where(user_id: user).first
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
