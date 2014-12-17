class TaskCategory < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :tasks

  validates :name, presence: true
end
