class User < ActiveRecord::Base
  # Extensions
  acts_as_tagger

  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  # Associations
  has_many :bookmarks
  has_many :links, through: :bookmarks
  has_many :likes, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy

  # Attributes
  attr_accessor :login

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Instance Methods
  def like(link)
    likes.create(link: link)
  end

  def to_param
    username
  end

  # Class Methods
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
        user.username = data['name'] if user.username.blank?
        user.provider = session['devise.facebook_data']['provider']
        user.uid = session['devise.facebook_data']['uid']
        user.valid?
      end
    end
  end
end
