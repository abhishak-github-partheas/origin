class CreateNotables < ActiveRecord::Migration
  def change
    create_table :notables do |t|
      t.string 'first_name'
      t.string 'last_name'
      t.integer 'number_of_t'
      t.timestamps
    end
  end
end
