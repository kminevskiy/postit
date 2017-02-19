class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  before_create :generate_slug

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create, length: { minimum: 3 }

  def generate_slug
    self.slug = self.username.parameterize
  end

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_through_twilio
    account_sid = "ACda0197398508c4e4e9ca90b290a3853a"
    auth_token = "a19ee119d0cd02ef8a5c9b272de40aa8"
    client = Twilio::REST::Client.new account_sid, auth_token

    message = "Hello, please input the pin to continue: #{self.pin}"
    account = client.account
    message = account.sms.messages.create({ from: "+17372103883", to: "+17023507632", body: message })
  end

  def to_param
    self.slug
  end

  def admin?
    self.role == "admin"
  end

  def moderator?
    self.role = "moderator"
  end
end
