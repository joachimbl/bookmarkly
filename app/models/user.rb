class User < ActiveRecord::Base
  # Extensions
  acts_as_tagger

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_and_belongs_to_many :links, uniq: true
  has_many :likes, inverse_of: :user

  # Attributes
  attr_accessor :login

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Instance Methods
  def like(link)
    likes.create(link: link)
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
end
