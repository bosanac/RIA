class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :naziv
      t.text :opis
      t.datetime :datumstart
      t.datetime :datumstop
      t.integer :pokusaja
      t.boolean :published
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
