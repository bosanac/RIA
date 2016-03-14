class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  
  #add_index :users, :email, unique: true

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }
    
  
  def change
      create_table :users do |t|
      t.string :name
      t.string :email
      
      t.timestamps null: false
    end
  end
end
