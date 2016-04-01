module QuizzesHelper
  
  def nazivKviza(id_kviza = nil)
    begin
      return Quiz.find(params[:id_quiz]).naziv unless id_kviza.nil?
    rescue
      ""
    end
  end

  def getOdgovoreNaPitanje(id_pitanja = nil)  
    begin
      return Odgovor.where("question_id = ?", id_pitanja) unless id_pitanja.nil?
    rescue
      ""
    end
  end
  
  def nazivPitanja(id)
    begin
    Question.select("pitanje").where(id: id)[0].pitanje
    rescue
    end
  end
  
  def nazivOdgovora(id)
    begin
    Odgovor.select("opcija").where(id: id)[0].opcija
    rescue
    end
  end
  
  def totalQuizDone(id)
    begin
    Rezultat.where(quiz_id: id).count
    rescue
    end
  end
  
  def isQuizValid(id)
    if Question.where(quiz_id: 12).count == 0
      Hash["valid" => false, "greska" => "Nemate definisanih pitanja u Vasem kvizu" + nazivKviza(id)]
    else
      # provjerimo da li su sva pitanja regularna
      Hash["valid" => true, "greska" => ""]
    end
    
 end
  
  
end
