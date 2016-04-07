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
  
  def rangLista(quiz_id)
    begin
      Rezultat.select("user_id, tacnihodg").where("quiz_id = ? AND tacnihodg > 0", quiz_id).order("tacnihodg DESC")
    rescue
      nil
    end
  end
  
  def nazivPitanja(id)
    begin
    Question.select("pitanje").where(id: id)[0].pitanje
    rescue
    end
  end
  
  def datumOdKviza(id)
    begin
      dat = DateTime.now.strftime("%m/%d/%Y")
      #Quiz.select("datumstart").where(id: id)[0].datumstart.to_s.strftime("%m/%d/%Y")
    rescue
      
    end  
  end
  
  def nazivOdgovora(id)
    begin
    Odgovor.select("opcija").where(id: id)[0].opcija
    rescue
    end
  end
  
  def nazviTacnogOdgovora(id_pitanja)
    begin
      Odgovor.joins(:question).where(questions:{id:id_pitanja}, odgovors: {tacan:1}).pluck(:opcija).to_s
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
