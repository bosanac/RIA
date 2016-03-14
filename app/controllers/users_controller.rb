class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    
    
    #za debagiranje otkomentirati debugger i prilikom startanja server
    #dovijamo bybug prompt i mozemo pregledati @user.name ili @user.email ili params[:id]

    #debugger

  end
  
  def new
    @user = User.new
  end
  
  def create
    
  end
  
end
