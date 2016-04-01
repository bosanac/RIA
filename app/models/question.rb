class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :odgovors
  
  validates_presence_of :pitanje, :message=>"Morate popuniti naziv pitanja", length: { maximum: 255 }
  validates_presence_of :quiz_id, :message=>"Morate popuniti na koji kviz se odnosi pitanje"
end
