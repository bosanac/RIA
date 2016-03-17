class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :naslov
      t.text :opis
      t.datetime :datumstart
      t.datetime :datumstop
      t.integer :pokusaja

      t.timestamps null: false
    end
  end
end
