class Notifier < ApplicationMailer
  
  default :from => 'turcinovic@gmail.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Hvala Vam na prijavu na sistem' )
  end
  
end
 