class RefreshToken < ApplicationRecord
  EXPIRATION = 24.hours
  belongs_to :user
  before_create :generate_secret

  scope :active, -> { where("expires_at > ? AND revoked_at IS NULL AND replaced_at IS NULL", Time.current) }

  def expired?
    Time.current >= expires_at
  end

  def revoked?
    revoked_at.present?
  end

  def replaced?
    replaced_at.present?
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  private

  def generate_secret
    self.secret = SecureRandom.hex(32)
    self.expires_at ||= EXPIRATION.from_now
  end
end
