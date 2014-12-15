require 'rails_helper'

RSpec.describe MailerUtility, :type => :model do

  it 'returns true if a block of code is successful' do
    expect(MailerUtility.try_delivery { true } ).to be true
  end

  it 'returns false if a block of code is unsuccessful' do
    expect(MailerUtility.try_delivery { fail IOError } ).to be false
  end


end
