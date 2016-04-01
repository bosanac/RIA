class Odgovor < ActiveRecord::Base
  belongs_to :question
  
  validates_presence_of :opcija, :message=>"Morate unijeti tekst Vaseg odgovora"
  validates_presence_of :question_id, :message=>"Morate odabrati na koje pitanje se odnosi odgovor"
  
end
