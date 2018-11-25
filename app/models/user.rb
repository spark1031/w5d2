class User < ApplicationRecord
  validates :name, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, :name, uniqueness: true

  attr_reader :password

  after_initialize :ensure_session_token


  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    user.try(:is_password?, password) ? user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end
  end
