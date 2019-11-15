class UserMailer < ApplicationMailer
  def set_password_email
    @user_attributes = params[:params]
    @not_yet_created_user = NotYetCreatedUser.create(@user_attributes)
    mail(to: @not_yet_created_user.email, subject: 'Set a password for your new account')
  end

  def reset_password_email
    @password_reset_params = params[:params]
    mail(to: @password_reset_params[:email], subject: 'Reset your password')
  end
end
