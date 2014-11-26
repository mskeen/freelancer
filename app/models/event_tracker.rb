class EventTracker < ActiveRecord::Base
  include LookupColumn

  belongs_to :user
  belongs_to :organization

  validates :name, presence: true
  validates :email, presence: true
  validates :interval_cd, presence: true

  before_create :generate_token

  TOKEN_LENGTH = 12

  lookup_group :interval, :interval_cd do
    option :minutes_30,       1, '30 Minutes', increment: 30.minutes
    option :hourly,           2, 'Hourly',     increment: 1.hour
    option :daily,            3, 'Daily',      increment: 1.day
    option :weekly,           4, 'Weekly',     increment: 7.days
    option :monthly,          5, 'Monthly',    increment: 1.month
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)[0..(TOKEN_LENGTH - 1)]
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
