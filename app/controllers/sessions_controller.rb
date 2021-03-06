class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Neispravna kombinacija emaila i passworda. Molimo pokusajte ponovo'
      render 'new'
    end
  end
  
  def destroy
    logout
    redirect_to root_url
  end
end
