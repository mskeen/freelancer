module Contactable

  extend ActiveSupport::Concern

  attr_accessor :contact_user_ids

  included do
    validate :validate_contacts_list
    after_save :save_contacts
  end

  def contact_user_ids
    @contact_user_ids || self.contacts.map(&:user_id)
  end

  def save_contacts
    current_list = contacts.map(&:user_id)
    new_list = contact_user_ids.inject([]) { |a, c| a << c.to_i if c != ""; a }
    (new_list - current_list).each { |user_id| contacts.create(user_id: user_id) }
    contacts.where(user_id: (current_list - new_list)).delete_all
  end

  def validate_contacts_list
    if (contact_user_ids.inject([]) { |a, c| a << c.to_i if c != ""; a }).size == 0
      errors.add(:contact_user_ids, 'must be specified')
    end
  end

end
