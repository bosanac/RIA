class Quiz < ActiveRecord::Base
  belongs_to :user
  
  # Dio za validaciju atributa u tabeli
  validates_presence_of :naziv, :message=>"Morate popuniti naziv Vaseg kviza"
  
end
