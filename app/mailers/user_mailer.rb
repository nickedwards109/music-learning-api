class UserMailer < ApplicationMailer
  def set_password_email
    @user_attributes = params[:params]
    @notYetCreatedUser = NotYetCreatedUser.create(@user_attributes)
    mail(to: @notYetCreatedUser.email, subject: 'Set a password for your new account')
  end
end
