class UpdatePage < ActiveRecord::Migration
  def up
  	add_column("pages", "subject_id", :integer)
  end

  def down
  end
end
