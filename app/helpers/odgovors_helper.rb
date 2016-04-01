module OdgovorsHelper
  
  def nazivPitanja(id_pitanja = nil)
    if !id_pitanja.nil?
      Question.find(params[:question_id]).pitanje unless id_pitanja.nil?
    end
  end  
  
  def nazivKviza_IDPitanja(id_pitanja)
    @id_kviza = Question.find(params[:question_id]).quiz_id unless id_pitanja.nil?
    Quiz.find(@id_kviza).naziv
  end
  
end
