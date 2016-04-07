module StraniceHelper
  
  def totalRezStat
    begin
      Rezultat.all.count
    rescue
    end
  end
  
  def totalUserStat
    begin
      User.all.count
    rescue
    end
  end
  
  def totalQuizStat
    begin
      Quiz.all.count
    rescue
    end
  end
  
end
