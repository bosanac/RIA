class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  # GET /questions
  # GET /questions.json
  def index
    session.delete(:quiz_id)
    
    @questions = Question.where("quiz_id = ?", params[:id_quiz])
    @odgovoraPoPitanju = Odgovor.group(:question_id).count
    
    begin
      session.delete(:question_id)
    rescue
      
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    
    if params[:quiz_id]
      session.delete(:quiz_id)
      session[:quiz_id] = params[:quiz_id]
      @question.attributes = {:quiz_id => params[:quiz_id].to_i}
    end
    
    @quizovi_korisnika  = Quiz.where("user_id = ?", session[:user_id])
    @quiz_id_sel = params[:quiz_trenutni]
  end

  # GET /questions/1/edit
  def edit
  end

  def dodajpitanje
    @question = Question.new(question_params)
    @question.quiz
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    parametri = question_params
    parametri[:quiz_id] = @quiz_id_sel
    @question = Question.new(question_params)
    session[:quiz_id] =  session[:quiz_id]
    respond_to do |format|
      if @question.save
        format.html {redirect_to action: "index", id_quiz: session[:quiz_id]}
        flash[:success] = "Uspjesno ste dodali novo pitanje kviz"
        @quiz_id_sel = nil
      else
        @quizovi_korisnika  = Quiz.where("user_id = ?", session[:user_id])
        session[:trenutni_id_kviza] = session[:trenutni_id_kviza]
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html {redirect_to action: "index", id_quiz: @question.quiz_id}
        flash[:success] = "Uspjesno ste izmjenili pitanje kviza"
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html {redirect_to action: "index", id_quiz: @question.quiz_id}
      flash[:success] = "Uspjesno ste obrisali pitanje kviza"
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:pitanje, :quiz_id)
    end
    
    
    def logged_in_user
      unless logged_in?
        #store_location
        flash[:danger] = "Molimo da se logujete na sistem"
        redirect_to login_url
      end
    end
    
    # provjera da li trazeno pitanje pripada datom logovano korisniku
    def correct_user
      @quiz_id_array_korisnika = Quiz.select("id").where(user_id: session[:user_id]).map {|quiz| quiz.id}
      @question_trazeni = Question.where("id = ?", params[:id]).take
      @validno_pitanje = false
      
      @quiz_id_array_korisnika.each do |id_kviza|
        if id_kviza.to_i == @question_trazeni[:quiz_id].to_i
          @validno_pitanje = true
          break
        end
      end
      
      if !@validno_pitanje
        flash[:danger] = "Nemate pravo pristupa ovom pitanju"
        redirect_to myquizzes_path
      end
    end
    
    
end
