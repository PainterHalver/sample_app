class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token

  before_save :downcase_email

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_20}
  validates :email,
            presence: true,
            length: {minimum: Settings.digit.length_10,
                     maximum: Settings.digit.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password,
            presence: true,
            length: {minimum: Settings.digit.length_6},
            allow_nil: true # tao moi van check o has_secure_password
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    return false if !remember_token || !remember_digest

    BCrypt::Password.new(remember_digest)
                    .is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
