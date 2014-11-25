module Features
  def sign_up_and_confirm(user)
    visit root_path

    click_on 'Sign Up'

    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Organization Name', with: user.organization.name
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    new_user = User.find_by_email(user.email)
    new_user.confirmed_at = Time.now
    new_user.save!
  end
end
