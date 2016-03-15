class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
    before_action :correct_user,   only: [:edit, :update]

 def index
  # @users = User.all
  
  # Prikaz korisnika da bi imali paging
  @users = User.paginate(page: params[:page])
 end

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
  
   def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Uspjesno izmjenjen profil!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
      # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
     # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
  
  private

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
