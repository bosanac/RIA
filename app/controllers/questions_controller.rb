class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  #before_action :set_kviz, only: [:index]
  
  
  #Client.where("created_at >= :start_date AND created_at <= :end_date",
  #{start_date: params[:start_date], end_date: params[:end_date]})
  
  
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.where("quiz_id = ?", params[:id_quiz])
    @odgovoraPoPitanju = Odgovor.group(:question_id).count
    
    begin
      session.delete[:question_id]
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
    

    
    respond_to do |format|

      
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
        @quiz_id_sel = nil
      else
        @quizovi_korisnika  = Quiz.where("user_id = ?", session[:user_id])
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
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
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
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:pitanje, :quiz_id)
    end
end
