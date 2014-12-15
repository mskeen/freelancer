class ApiKey < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  TOKEN_LENGTH = 32

  validates :user_id, presence: true
  validates :organization_id, presence: true

  before_create :generate_token

  default_scope { where(is_active: true) }

  private

  def generate_token
    self.token = loop do
      random_token =
        SecureRandom.hex[0..(TOKEN_LENGTH - 1)]
      break random_token unless self.class.exists?(token: random_token)
    end
  end

end
