class QuizzesController < ApplicationController
  
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  
  before_action :vrijemeStart, only: [:prepare_quiz]
  # GET /quizzes
  # GET /quizzes.json
  
  def index
    
    if !params[:search].nil?
      @quizzes = Quiz.search(params[:search]).order("created_at DESC").paginate(page: params[:page])
    else
    # @quiz = Quiz.new
   # @quizzes = Quiz.all
    #@users = User.paginate(page: params[:page])
    
      if params[:usrid_search]
        @quizzes = Quiz.paginate(page: params[:page]).where(published: "1", user_id: params[:usrid_search].to_i).order("created_at DESC")
      else
        @quizzes = Quiz.paginate(page: params[:page]).where(published: "1").order("created_at DESC")
      end
    end
    
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
  end
  
  def mykvizes
    
    if params[:actideactiv_id] && params[:status]

      if(params[:status].to_i == 1)
        provjera_kviza = isQuizValid(params[:actideactiv_id], params[:status])
        if provjera_kviza["valid"]
          kviz_updt = Quiz.find_by(id: params[:actideactiv_id])
          kviz_updt.update(published: params[:status])
          flash[:success] = provjera_kviza["poruka"]
          redirect_to action: "mykvizes" 
        else
          flash[:danger] = provjera_kviza["poruka"]
        end
     else
       kviz_updt = Quiz.find_by(id: params[:actideactiv_id])
       kviz_updt.update(published: params[:status])
       
       provjera_kviza = isQuizValid(params[:actideactiv_id], params[:status])
       flash[:success] = provjera_kviza["poruka"]
       redirect_to action: "mykvizes" 
     end
   end
    
    @quizzes  = Quiz.where("user_id = ?", session[:user_id])
    @brPitanjaPoKvizu = Question.group(:quiz_id).count
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


  def prepare_quiz
    @tacna_pitanja = Hash.new
    @tacna_pitanja.default(key = nil)
    session[:tacna_pitanja] = @tacna_pitanja
   
    session[:kviz_id] = params[:id]
   # session[:pitanja] = Question.where("quiz_id = ?", params[:id])
    session[:datstart] = DateTime.now
    session[:datstop] = nil
    session[:ukupo_pitanja]   = Question.where("quiz_id = ?", params[:id]).count.to_i
    session[:trenutno_pitanje] = 0
    session[:ispravnih_odgovora] = 0

    redirect_to action: "start", id: params[:id], rbr: params[:rbr]
  end

  def start
  
    if session[:datstop].nil?
      @ukupnoPitanja = session[:ukupo_pitanja]
      @rbrPitanja = params[:rbr]
      session[:trenutno_pitanje] = @rbrPitanja.to_i
      @quiz = Quiz.find(params[:id])
      @question_of_quiz = Question.where("quiz_id = ?", params[:id])
      @odgovor = Odgovor.new
    #  session.delete(:datstart)
    #  session[:datstart] = DateTime.new(2012, 8, 29, 22, 35, 0)
    else
      
    end
    
    eval_odgovor(params[:odgovorid], Odgovor.select("question_id").where(id:params[:odgovorid])[0].question_id) if !params[:odgovorid].nil?
  
  end
  

  def kraj
    
    
  #  session[:datstop] = DateTime.now
  #  @procUspjesnosti = (session[:ispravnih_odgovora].to_i*100)/session[:ukupo_pitanja].to_i
  #  @tacnoOdgovorenih = session[:ispravnih_odgovora].to_i
  #  @ukupnoPitanja = session[:ukupo_pitanja].to_i
    
    begin
      session[:datstop] = DateTime.now
      
      @procUspjesnosti = (session[:ispravnih_odgovora].to_i*100)/session[:ukupo_pitanja].to_i
      @tacnoOdgovorenih = session[:ispravnih_odgovora].to_i
      
      upisiRezultat @procUspjesnosti, @tacnoOdgovorenih
      redirect_to action: "rezultat", id: session[:kviz_id]
    rescue
      
    end
    
   #@diff = (session[:datstop].to_datetime - session[:datstart].to_datetime).to_s
    #flash[:succes] = "Startano: " + session[:datstart] + " ukupno: " + @diff
   # flash[:success] = "Broj tacnih odgovora: " + @startTime + " " + "Tacna pitanja odgovorena: " + session[:tacna_pitanja].keys.to_s + " - " + session[:tacna_pitanja].values.to_s
  end
  
  def rezultat
    
  end
  
  private
  
  def isQuizValid(id, status)
    if Question.where(quiz_id: id).count == 0
      # kviz nema definisanih pitanja
      Hash["valid" => false, "poruka" => "Nemate definisanih pitanja u Vasem kvizu = >"  + Quiz.find(id).naziv]
    else
      # provjerimo da li su sva pitanja regularna idemo pitanje po pitanje
      
      pitanja_kviza = Question.where(quiz_id: id)
      brOdogovoraPoPitanju = 0
      nazivKviza = Quiz.find(id).naziv
      brojTacnihOdgovora = 0
      brojNetacnihOdgovora = 0
      
      pitanja_kviza.each do |pitanje|
        brOdogovoraPoPitanju = 0
        brOdogovoraPoPitanju = Odgovor.where(question_id: pitanje.id).count
        
        brojTacnihOdgovora = 0
        brojTacnihOdgovora = Odgovor.where(question_id: pitanje.id, tacan: 1).count
        
        brojNetacnihOdgovora = 0
        brojNetacnihOdgovora = Odgovor.where(question_id: pitanje.id, tacan: 0).count
        
        # provjera ima li pitanje odgovora
        if brOdogovoraPoPitanju  == 0
          return Hash["valid" => false, "poruka" => "Kviz ['"  + nazivKviza + "'] i pitanje ['" + pitanje.pitanje + "'] nema ni jednog odogora!. Molimo unesite barem dva odgovora ili obrisite pitanje"]
        end
        
        if brOdogovoraPoPitanju == 1
          return Hash["valid" => false, "poruka" => "Kviz ['"  + nazivKviza + "'] i pitanje ['" + pitanje.pitanje + "'] mora imati dva odgovora minimalno!. Molimo unesite barem dva odgovora ili obrisite pitanje"]
        end
        
        if brOdogovoraPoPitanju >= 2 
          if brojTacnihOdgovora.to_i != 1
            return Hash["valid" => false, "poruka" => "Kviz ['"  + nazivKviza + "'] i pitanje ['" + pitanje.pitanje + "'] mora imati samo jedan tacan odgovor!. Molimo unesite barem dva odgovora ili obrisite pitanje"]
          end
        end
        
      end
      
      if status.to_i == 1
        txt_status = "aktivirali"
      else
        txt_status = "deaktivirali"
      end

      Hash["valid" => true, "poruka" => "Uspjesno ste " + txt_status + " kviz =>"  + Quiz.find(id).naziv]
    end
    
  end
  
    def ocistiSesVarijable
      session.delete(:ispravnih_odgovora)
      session.delete(:ukupo_pitanja)
      session.delete(:ispravnih_odgovora)
    end
  
  
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

  def upisiRezultat(postotak, tacnih_odgovora)  
    @rz = Rezultat.create(postotak: postotak, tacnihodg: tacnih_odgovora, dtstart: session[:datstart], dtkraj: session[:datstop], quiz_id: session[:quiz_id], user_id: session[:user_id])  
  end
  
  def eval_odgovor(id_odgovora, id_pitanja)
    if Odgovor.where("id=? AND tacan=?", id_odgovora,true).count.to_i == 1
     session[:tacna_pitanja][id_pitanja] = id_odgovora.to_i 
     session[:ispravnih_odgovora] = session[:ispravnih_odgovora].to_i + 1
    else
      @tacna_pitanja = session[:tacna_pitanja]
      @hash_temp = Hash.new
      @tacna_pitanja.each { |key,value| @hash_temp[key] = value if key.to_i != id_pitanja.to_i }
      session[:tacna_pitanja] = @hash_temp
      session[:ispravnih_odgovora] = session[:ispravnih_odgovora].to_i - 1 if @tacna_pitanja.length != @hash_temp.length
    end
  end

  def vrijemeStart
    session[:datstart] = DateTime.now
  end
    

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        #store_location
        flash[:danger] = "Molimo da se logujete na sistem"
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
