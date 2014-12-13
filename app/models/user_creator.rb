class UserCreator

  PASSWORD_LENGTH = 8

  def initialize(user)
    @user = user
  end

  def create
    @user.password = @user.password_confirmation = pw = generate_password
    @user.confirmed_at = Time.zone.now
    if @user.save && @user.is_invited
      if !invite(@user, pw)
        @user.destroy
        @user.errors.add(:email, "invitation failed - please check the address")
      end
    end
  end

  def generate_password
    SecureRandom.hex[0..(PASSWORD_LENGTH - 1)]
  end

  def invite(user, pw)
    MailerUtility.try_delivery do
      InvitationMailer.invite(user, pw).deliver
    end
  end

end
