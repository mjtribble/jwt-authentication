class User < ApplicationRecord
  has_secure_password
  has_many :refresh_tokens, dependent: :destroy
end
