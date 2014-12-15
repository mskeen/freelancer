class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :alertable, polymorphic: true

  delegate :email, to: :user
end
