class Quiz < ActiveRecord::Base
  belongs_to :user
  has_many :questions, dependent: :destroy
  # Dio za validaciju atributa u tabeli
  validates_presence_of :naziv, :message=>"Morate popuniti naziv Vaseg kviza", length: { maximum: 255 }
end
