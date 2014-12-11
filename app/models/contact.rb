class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  validates :name, presence: true
  validates :email, presence: true
end
