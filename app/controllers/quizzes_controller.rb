class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzes = Quiz.all
    #@users = User.paginate(page: params[:page])
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
  end
  
  def mykvizes
    @quizzes_my  = Quiz.where("user_id = ?", session[:user_id])
    #Quiz.all.collect {|obj| obj.user_id = session[:user_id]}
    # @quizzes_my = Quiz.find_by user_id: session[:user_id]
  end

  # GET /quizzes/new
  def new
   # if logged_in?
      @quiz = Quiz.new
    #else
     # redirect_to login_path
    #end
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    parametri = quiz_params
    parametri[:user_id] = session[:user_id]
    @quiz = Quiz.new(parametri)
    @quiz.user 
    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz}
        flash[:success] = "Quiz was successfully created."
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz }
        flash[:success] = "Quiz was successfully updated."
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to quizzes_url, notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end


    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        #store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
         # Confirms the correct user.
    def correct_user
      @quiz_correct = Quiz.where("user_id = ? AND id = ?", session[:user_id], params[:id]).take
      if @quiz_correct.nil?
        redirect_to(root_url) 
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:naziv, :opis, :datumstart, :datumstop, :pokusaja, :user_id)
    end
    
    
    
end
