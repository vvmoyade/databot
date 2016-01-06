class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :mywebsites
  has_one :profile,:through=> :mywebsites
  validates :name, :presence => true

  def self.from_omniauth(auth)
    data = auth.info
    user = where(uid: auth.uid).first_or_create
    user.name = data.name 
    user.email = data.email if data.email.present?
    user.password = Devise.friendly_token[0,20] if user.password.blank?
    user.uid = auth.uid
    user.google_token = auth.credentials.token
    user.google_secret = auth.credentials.secret
    user.save
    user
  end

end
