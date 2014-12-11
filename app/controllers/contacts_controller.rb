class ContactsController < ApplicationController
  before_filter :authenticate_user!, except: [:ping]
  respond_to :html, :js

  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def new
    @contact = current_user.contacts.new
  end

  def edit
  end

  def create
    @contact = current_user.contacts.new(contact_params)
    @contact.organization = current_user.organization
    @contact.save
    respond_with(@contact)
  end

  def update
    @contact.update(contact_params)
    respond_with(@contact)
  end

  def destroy
    @contact.update_attributes(is_deleted: true)
    respond_with(@contact, location: contacts_path)
  end

  private

  def set_contact
    @contact = current_user.contacts.active.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email)
  end

end
