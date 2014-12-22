class Task < ActiveRecord::Base
  include LookupColumn

  belongs_to :user
  belongs_to :task_category

  lookup_group :frequency, :frequency_cd do
    option :none,         0, 'None',          interval: 0
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

end
