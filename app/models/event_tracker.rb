# Model EventTracker
class EventTracker < ActiveRecord::Base
  include LookupColumn
  include Contactable

  belongs_to :user
  belongs_to :organization
  has_many :contacts, as: :alertable
  has_many :pings, class_name: 'EventTrackerPing', dependent: :destroy

  validates :name, presence: true
  validates :interval_cd, presence: true
  validates :status_cd, presence: true

  before_create :generate_token
  before_save :update_next_check_at

  TOKEN_LENGTH = 12
  BUFFER = 5.minutes

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
  scope :due, -> { where('next_check_at <= ?', Time.zone.now + BUFFER) }
  scope :running, -> { where(
    status_cd: [ EventTracker.status(:ok).id, EventTracker.status(:alert).id ]
  ) }

  def ping(task_length = nil, comment = nil)
    pings.create(task_length: task_length, comment: comment)
    touch(:last_ping_at)
    status_manager.change_to_status(EventTracker.status(:ok))
  end

  def check(check_start_at)
    self.last_checked_at = check_start_at
    if last_ping_at >= (check_start_at - self.interval.increment)
      status_manager.change_to_status(EventTracker.status(:ok))
    else
      status_manager.change_to_status(EventTracker.status(:alert))
    end
    save!
  end

  def to_param
    token
  end

  def emails
    contacts.map { |c| c.email }
  end

  def due?
    last_checked_at.nil? ||
      (last_checked_at + interval.increment < Time.zone.now)
  end

  private

  def status_manager
    @status_manager ||= EventTrackerStatusManager.new(self)
  end

  def generate_token
    self.token = loop do
      random_token =
        SecureRandom.hex[0..(TOKEN_LENGTH - 1)]
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def update_next_check_at
    if last_checked_at && (last_checked_at_changed? || interval_cd_changed?)
      self.next_check_at = last_checked_at + interval.increment
    end
  end

end
