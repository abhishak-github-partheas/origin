class CreateUsersPagesJoin < ActiveRecord::Migration
  def up
  	create_table :pages_users, :id => false do |t|
  		t.integer "user_id"
  		t.integer "page_id"
    end
    add_index :users_pages, ["user_id", "page_id"]
  end
    
  def down
  end
end
