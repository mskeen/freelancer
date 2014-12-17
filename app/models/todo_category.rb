class TodoCategory < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :todos

  validates :name, presence: true
  validates :short_name, presence: true
end
