class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include LookupColumn

  belongs_to :organization
  has_many :event_trackers

  lookup_group :role, :role_cd do
    option :root,       1, 'Root'
    option :admin,      2, 'Admin'
    option :contact,    9, 'Contact'
    option :guest,     99, 'Guest'
  end

  validates :name, presence: true
  validates :role_cd, inclusion: { in: User.roles.map(&:id) }

  accepts_nested_attributes_for :organization

  after_create :assign_organization_user

  scope :active, -> { where(is_active: true) }

  def admin?
    [User.role(:admin), User.role(:root)].include? role
  end

  def root?
    role == User.role(:root)
  end

  private

  def assign_organization_user
    organization.update_attribute(:user_id, id) if root?
  end
end
