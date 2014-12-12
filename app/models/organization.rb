class Organization < ActiveRecord::Base
  has_many :users
  has_many :event_trackers
  belongs_to :user

  validates :name, presence: true
end
