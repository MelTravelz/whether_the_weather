class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password_digest, presence: true

  # when I turn bcrypt on: 
  # validates :password, presence: true
  # has_secure_password
end