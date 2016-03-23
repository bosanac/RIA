class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  #has_many :quizzes
  #add_index :users, :email, unique: true

 # validate :validateName
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }
  
   # Vraca HASH za dati string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end  
  
  def change
      create_table :users do |t|
      t.string :name
      t.string :email
      
      t.timestamps null: false
    end
  end
  
  
  def validateName
    if :name.present?
      errors.add(:name,"Morate popuniti Login name")
    end
    
    if :name.present? && :name.size > 50
      errors.add(:name,"Login name ne smije biti veci od 50")
    end
  end
  
  
end
