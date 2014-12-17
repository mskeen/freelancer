class TaskCategory < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :tasks

  validates :name, presence: true

  before_create :set_organization

  default_scope { where(is_active: true) }

  private

  def set_organization
    self.organization = user.organization
  end

  def self.for_user(user)
    user.organization.task_categories
      .where(["user_id = ? or is_shared = ?", user.id, true])
  end
end
