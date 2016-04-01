module ApplicationHelper
  
  def formatInt(broj)
    if broj.nil?
      "0"
    else
      broj
    end
  end
  
  def formatTacanNetaca(opcija)
    if opcija
      "DA"
    else
      "NE"
    end
  end
  
end
