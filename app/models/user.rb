class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization
  has_many :event_trackers
  has_many :contacts

  ROLE_ROOT = 'root'
  ROLE_ADMIN = 'admin'
  ROLE_CONTACT = 'contact'
  AVAILABLE_ROLES = [ROLE_ROOT, ROLE_ADMIN, ROLE_CONTACT]

  validates :name, presence: true
  validates :role, inclusion: { in: AVAILABLE_ROLES }

  accepts_nested_attributes_for :organization

end
