class CreateQuestions < ActiveRecord::Migration
  
  def change
    create_table :questions do |t|
      t.text :pitanje
      t.belongs_to :quiz, index: true
      t.timestamps null: false
    end
  end
  
  def self.down
    drop_table :questions
  end
  
end
