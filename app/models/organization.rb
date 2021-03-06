class Organization < ActiveRecord::Base
  has_many :users
  has_many :sites
  has_many :event_trackers
  has_many :api_keys
  has_many :task_categories
  belongs_to :user

  validates :name, presence: true
end
