require 'rails_helper'

RSpec.describe Contact, :type => :model do
  it { should belong_to :user }
  it { should belong_to :organization }
end
