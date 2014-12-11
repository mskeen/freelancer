class Organization < ActiveRecord::Base
  has_many :users
  has_many :event_trackers
  has_many :contacts

  validates :name, presence: true
end
