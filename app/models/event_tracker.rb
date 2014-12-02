# Model EventTracker
class EventTracker < ActiveRecord::Base
  include LookupColumn

  belongs_to :user
  belongs_to :organization

  validates :name, presence: true
  validates :email, presence: true
  validates :interval_cd, presence: true
  validates :status_cd, presence: true
  validate :validate_email_list

  before_create :generate_token

  TOKEN_LENGTH = 12

  lookup_group :interval, :interval_cd do
    option :minutes_30,       1, '30 Minutes', increment: 30.minutes
    option :hourly,           2, 'Hourly',     increment: 1.hour
    option :daily,            3, 'Daily',      increment: 1.day
    option :weekly,           4, 'Weekly',     increment: 7.days
    option :monthly,          5, 'Monthly',    increment: 1.month
  end

  lookup_group :status, :status_cd do
    option :pending,          1, 'Pending'
    option :ok,               2, 'Ok'
    option :paused,           3, 'Paused'
    option :alert,            4, 'Alert'
  end

  scope :active, -> { where(is_deleted: false) }

  def ping
  end

  def to_param
    token
  end

  def emails
    email ? email.split(',').map(&:strip) : []
  end

  private

  def generate_token
    self.token = loop do
      random_token =
        SecureRandom.urlsafe_base64(nil, false)[0..(TOKEN_LENGTH - 1)]
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def validate_email_list
    emails.each do |addr|
      unless addr.match(/\A[^@]+@[^@]+\z/)
        errors.add(:email, 'must be valid format and separated by commas')
      end
    end
  end
end
