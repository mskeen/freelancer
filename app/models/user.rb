class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  has_many :event_trackers
  has_many :contacts

  validates :name, presence: true

  accepts_nested_attributes_for :organization
end
