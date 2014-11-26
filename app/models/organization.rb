class Organization < ActiveRecord::Base
  has_many :users
  has_many :event_trackers

  validates :name, presence: true
end
