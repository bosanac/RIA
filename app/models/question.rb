class Question < ActiveRecord::Base
  belongs_to :quiz
  
  validates_presence_of :pitanje, :message=>"Morate popuniti naziv pitanja", length: { maximum: 255 }
  
end
