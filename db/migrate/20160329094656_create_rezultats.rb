class CreateRezultats < ActiveRecord::Migration
  def change
    create_table :rezultats do |t|
      t.string :postotak
      t.integer :tacnihodg
      t.datetime :dtstart
      t.datetime :dtkraj
      t.belongs_to :quiz, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
