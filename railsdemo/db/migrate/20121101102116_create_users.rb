class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      #t.integer "id"
      t.string "first_name"	
      t.string "last_name"
      t.string "email", :default => "", :null => false
      t.string "password", :limit => 40
      #t.datetime "created_at"
      #t.datetime "updated_at"
      t.timestamps
    end
  end
end
