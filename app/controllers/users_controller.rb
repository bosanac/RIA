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
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
    # Uspjesno popunjen i sacuvan korisnik
      log_in @user
      flash[:success] = "Dobro dosli, uspjesno ste kreirali korisnicki nalog!"
      redirect_to @user
    else
    # Nije uspjesno sacuvan korisnik
    flash[:success]
    render 'new'
    end
  end
  
  
  private

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
