class CreateOdgovors < ActiveRecord::Migration
  def change
    create_table :odgovors do |t|
      t.text :opcija
      t.boolean :tacan
      
      t.belongs_to :question, index: true
      
      t.timestamps null: false
    end
  end
end
