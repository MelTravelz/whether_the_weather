class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  # validates :password_digest, presence: true

  validates :password, presence: true
  has_secure_password
end