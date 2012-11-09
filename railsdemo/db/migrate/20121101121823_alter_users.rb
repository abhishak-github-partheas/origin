class AlterUsers < ActiveRecord::Migration
  def up
  	add_column("users", "new_column1", :string)
  	add_column("users", "new_column2", :string)
  	rename_column("users", "first_name", "user_first_name")
  	rename_column("users", "last_name", "user_last_name")
  	add_column("subjects", "sub_first_name", :string)
  	add_column("subjects", "sub_last_name", :string)
  end

  def down
  end
end
