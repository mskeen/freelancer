class Task < ActiveRecord::Base
  include LookupColumn

  belongs_to :user
  belongs_to :task_category
  belongs_to :completed_by_user, class_name: 'User',
             foreign_key: :completed_by_user_id
  has_one :spawned_task, class_name: 'Task', foreign_key: :spawned_task_id

  lookup_group :frequency, :frequency_cd do
    option :none,         0, 'None',          interval: 0.days
    option :daily,        1, 'Daily',         interval: 1.day
    option :weekly,       2, 'Weekly',        interval: 1.week
    option :biweekly,     3, 'Biweekly',      interval: 2.weeks
    option :monthly,      4, 'Monthly',       interval: 1.month
    option :bimonthly,    5, 'Bimonthly',     interval: 2.months
    option :quarterly,    6, 'Quarterly',     interval: 3.months
    option :semiannually, 7, 'Semiannually',  interval: 6.months
    option :annually,     8, 'Annually',      interval: 1.year
  end

  validates :title, presence: true
  validates :weight, presence: true
  validates :frequency_cd, presence: true

  default_scope { where(is_active: true) }
  scope :incomplete, -> { where(completed_at: nil) }

  def complete!(user)
    fail 'AlreadyCompleteError' if completed_at
    spawn_new_task if self.frequency != Task.frequency(:none)
    update_attributes(
      completed_at: Time.zone.now,
      completed_by_user_id: user.id
    )
  end

  def undo_completion!
    fail 'NotCompleteError' unless self.completed_at
    update_attributes(
      completed_at: nil,
      completed_by_user_id: nil
    )
    self.spawned_task.destroy if self.spawned_task
  end

  def complete?
    completed_at.present?
  end

  private

  def spawn_new_task
    self.spawned_task = self.dup
    self.spawned_task.due_date = (self.due_date || Time.zone.now) +
      self.frequency.interval
    self.spawned_task.save!
  end
end
