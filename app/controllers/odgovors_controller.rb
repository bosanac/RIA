class OdgovorsController < ApplicationController
  before_action :set_odgovor, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  # GET /odgovors
  # GET /odgovors.json
  def index
    @odgovors = Odgovor.where("question_id = ?", params[:question_id])
    begin
      session[:question_id] = params[:question_id]
    rescue
      
    end
  end

  # GET /odgovors/1
  # GET /odgovors/1.json
  def show
  end

  # GET /odgovors/new
  def new
    session[:question_id] = params[:id_pitanja]
    
    @odgovor = Odgovor.new
    
    #ukoliko imamo postavljen parametar question_id odabiremo to trenutno pitanje
    
    if params[:question_id]
      @odgovor.attributes = {:question_id => params[:question_id].to_i}
    end

    @trenutno_pitanje = params[:question_id]
    @trenutni_kviz = params[:quiz_id]
    session[:question_id] = @trenutno_pitanje
    session[:quiz_id] = @trenutni_kviz
      if !params[:quiz_id].nil?
        @pitanja_korisnika =  Question.where("quiz_id = ?", params[:quiz_id])
      else
        @pitanja_korisnika = Question.where(quiz_id: Quiz.select("id").where(user_id: session[:user_id]).pluck(:id))
      end 
  end

  # GET /odgovors/1/edit
  def edit
    @pitanja_korisnika =  Question.where(quiz_id: Quiz.select("id").where(user_id: session[:user_id]).pluck(:id))
    
  end

  # POST /odgovors
  # POST /odgovors.json
  def create
    @greska = false
    @odgovor = Odgovor.new(odgovor_params)
   
    if @odgovor.tacan && brojTacnihOdgovora(session[:question_id]) == 1
      @pitanja_korisnika =  Question.where("quiz_id = ?", session[:quiz_id])
      @greska = true;
      #redirect_to action: 'new', question_id: session[:question_id]
    end
    
    @odgovor = Odgovor.new(odgovor_params)

    respond_to do |format|
      if @greska
        flash[:danger] = "Vec imate postavljen jedan odgovor na tacan"
        @pitanja_korisnika =  Question.where("quiz_id = ?", session[:question_id])
        redirect_to action: 'index', question_id: session[:question_id] 
        return
      end
      
      if @odgovor.save
        flash[:success] = "Uspjesno ste dodali novi odgovor na pitanje"
        format.html { redirect_to action: 'index', question_id: session[:question_id]}
        format.json { render :show, status: :created, location: @odgovor }
        
        begin
          @trenutni_kviz = nil
          @trenutno_pitanje = nil
          session.delete[:question_id]
        rescue
        end
      else
   
        @pitanja_korisnika = Question.where(quiz_id: Quiz.select("id").where(user_id: session[:user_id]).pluck(:id))
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
        format.html { redirect_to action: 'index', question_id: session[:question_id]}
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
      flash[:warning] = "Uspjesno obrisan odogovor na pitanje"
      format.html { redirect_to action: 'index', question_id: session[:question_id] }
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
      Odgovor.where("question_id = ? AND tacan = ?", idPitanja,true).count.to_i
    end

    def odgovor_params
      params.require(:odgovor).permit(:opcija, :tacan, :question_id)
    end
    
    def logged_in_user
      unless logged_in?
        #store_location
        flash[:danger] = "Molimo da se logujete na sistem"
        redirect_to login_url
      end
    end
    
    
    # provjera da li trazeni odgovor pripada datom logovano korisniku
    def correct_user
      @question_id_array_korisnika = Question.select("id").where(quiz_id: Quiz.select("id").where(user_id: session[:user_id])).map{|pitanje| pitanje.id}
      @odgovor_trazeni = Odgovor.where("id = ?", params[:id]).take
      @validan_odgovor = false
      
      @question_id_array_korisnika.each do |id_pitanja|
        if id_pitanja.to_i == @odgovor_trazeni[:question_id].to_i
          @validan_odgovor = true
          break
        end
      end
      
      if !@validan_odgovor
        flash[:danger] = "Nemate pravo pristupa ovom odgovoru"
        redirect_to myquizzes_path
      end
    end
    
    
end
