class InvitationMailer < ActionMailer::Base
  default from: AppConfig.support_email

  def invite(user, password)
    @user = user
    @password = password
    mail to: user.email,
         subject: "#{@user.creator.name} has invited you"
  end

end
