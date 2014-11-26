module Features
  def sign_in_existing_user
    user = FactoryGirl.build(:user)
    user.confirmed_at = Time.now
    user.save
    sign_in(user)
    user
  end
end
