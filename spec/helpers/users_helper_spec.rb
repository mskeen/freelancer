require 'rails_helper'

RSpec.describe UsersHelper, :type => :helper do

  it "should not include the root role" do
    expect(roles_for_select).to_not include User.role(:root)
  end

  it "should not include the guest role" do
    expect(roles_for_select).to_not include User.role(:guest)
  end

  it "should include other roles" do
    User.roles.each do |role|
      if role.name != :guest && role.name != :root
        expect(roles_for_select).to include role
      end
    end
  end

end
