class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string "subject_first_name"	
      t.string "subject_last_name"
      t.timestamps
    end
  end
end
