# Model Site
class Site < ActiveRecord::Base
  include LookupColumn
  include Contactable

  belongs_to :user
  belongs_to :organization
  has_many :contacts, as: :alertable
  has_many :log_monitors

  validates :name, presence: true
  validates :interval_cd, presence: true
  validates :status_cd, presence: true

  before_create :generate_token
  before_save :update_next_check_at

  TOKEN_LENGTH = 12
  BUFFER = 5.minutes

  lookup_group :interval, :interval_cd do
    option :minutes_1,        1, '1 Minute',   increment: 1.minutes
    option :minutes_2,        2, '2 Minutes',  increment: 2.minutes
    option :minutes_5,        3, '5 Minutes',  increment: 5.minutes
    option :minutes_10,       4, '10 Minutes', increment: 10.minutes
    option :minutes_10,       5, '15 Minutes', increment: 15.minutes
    option :minutes_10,       6, '30 Minutes', increment: 30.minutes
    option :hourly,           7, 'Hourly',     increment: 1.hour
  end

  lookup_group :status, :status_cd do
    option :pending,          1, 'Pending'
    option :ok,               2, 'Ok'
    option :paused,           3, 'Paused'
    option :down,             4, 'Down'
  end

  scope :active, -> { where(is_deleted: false) }
  scope :due, -> { where('next_check_at <= ?', Time.zone.now + BUFFER) }

  def to_param
    token
  end

  def due?
    last_checked_at.nil? ||
      (last_checked_at + interval.increment < Time.zone.now)
  end

  private

  def generate_token
    self.token = loop do
      random_token =
        SecureRandom.hex[0..(TOKEN_LENGTH - 1)]
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def update_next_check_at
    return if last_checked_at.nil? ||
              !(last_checked_at_changed? || interval_cd_changed?)
    self.next_check_at = last_checked_at + interval.increment
  end
end
