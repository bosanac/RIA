class OdgovorsController < ApplicationController
  before_action :set_odgovor, only: [:show, :edit, :update, :destroy]
  #before_action :prethodni_url, only: [:show, :edit, :update, :destroy]
  # GET /odgovors
  # GET /odgovors.json
  def index
    @odgovors = Odgovor.where("question_id = ?", params[:question_id])
    
    begin
      session.delete[:question_id]
    rescue
      
    end
    
  #      @questions = Question.where("quiz_id = ?", params[:id_quiz])
   # @odgovoraPoPitanju = Odgovor.group(:question_id).count
  end

  # GET /odgovors/1
  # GET /odgovors/1.json
  def show
  end

  # GET /odgovors/new
  def new
    @odgovor = Odgovor.new
    
    #ukoliko imamo postavljen parametar question_id odabiremo to trenutno pitanje
    
    if params[:question_id]
      @odgovor.attributes = {:question_id => params[:question_id].to_i}
    end

    @trenutno_pitanje = params[:question_id]
    @trenutni_kviz = params[:quiz_id]
    session[:question_id] = @trenutni_kviz
    session[:quiz_id] = @trenutni_kviz
   # if params[:pitanje_trenutno].nil?
    #  @pitanja_korisnika = Odgovor.where("user_id = ?", session[:user_id])
    #else 
   # session[:id_pitanja] ||= params[:pitanje_trenutno]
      #@pitanja_korisnika =  Odgovor.joins(:question).where("quiz_id = ?", session[:id_pitanja])
      if !params[:quiz_id].nil?
        @pitanja_korisnika =  Question.where("quiz_id = ?", params[:quiz_id])
      else
        @pitanja_korisnika = Question.where(quiz_id: Quiz.select("id").where(user_id: session[:user_id]).pluck(:id))
      end 
      #Question.where("question_id = ?", params[:pitanje_trenutno])
    #end
   # session[:id_pitanja] ||= params[:pitanje_trenutno]
    #flash[:success] = @trenutni_kviz + " " + @trenutno_pitanje  
  end

  # GET /odgovors/1/edit
  def edit
    @pitanja_korisnika =  Question.where("quiz_id = ?", session[:question_id])
    session[:return_to] ||= request.referer
  end

  # POST /odgovors
  # POST /odgovors.json
  def create
    @greska = false
    
    if params[:tacan] == 1 && brojTacnihOdgovora(session[:question_id])
      
      @pitanja_korisnika =  Question.where("quiz_id = ?", session[:quiz_id])
      @greska = true;
      
    end
    
    @odgovor = Odgovor.new(odgovor_params)
    
    #@odgovor.update(question_id: session.delete(:id_pitanja))
    
    respond_to do |format|
      if @greska
        flash[:danger] = "Vec imate postavljen jedan odgovor na tacan"
        @pitanja_korisnika =  Question.where("quiz_id = ?", session[:question_id])
        format.html { render :new }
        format.json { render json: @odgovor.errors, status: :unprocessable_entity }
      end
      
      if @odgovor.save
        format.html { redirect_to @odgovor, notice: 'Odgovor was successfully created.' }
        format.json { render :show, status: :created, location: @odgovor }
        
        begin
          @trenutni_kviz = nil
          @trenutno_pitanje = nil
          session.delete[:question_id]
        rescue
        end
      else
        @pitanja_korisnika =  Question.where("quiz_id = ?", session[:question_id])
        format.html { render :new }
        format.json { render json: @odgovor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /odgovors/1
  # PATCH/PUT /odgovors/1.json
  def update
    @id_trenutnog_pitanja = Odgovor.select("question_id").where(id: params[:id].to_i)[0].question_id
    
    respond_to do |format|
      if @odgovor.update(odgovor_params)
        flash[:success] = "Uspjesno ste azurirali Vas odgovor na pitanje"
        #redirect_to 
        format.html { render :show}
        format.json { render :show, status: :ok, location: @odgovor }
      else
        format.html { render :edit }
        format.json { render json: @odgovor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /odgovors/1
  # DELETE /odgovors/1.json
  def destroy
    @odgovor.destroy
    respond_to do |format|
      format.html { redirect_to odgovors_url, notice: 'Odgovor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_odgovor
      @odgovor = Odgovor.find(params[:id])
    end
    
    def prethodi_url
      session[:return_to] ||= request.referer
    end
    
    def brojTacnihOdgovora(idPitanja)
      Odgovor.where("question_id = ? AND tacan = ?", idPitanja,true).count
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def odgovor_params
      params.require(:odgovor).permit(:opcija, :tacan, :question_id)
    end
end
