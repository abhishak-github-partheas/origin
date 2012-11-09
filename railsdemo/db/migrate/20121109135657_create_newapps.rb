class CreateNewapps < ActiveRecord::Migration
  def change
    create_table :newapps do |t|
      t.string :name
      t.string :data
      t.int :id
      t.string :value

      t.timestamps
    end
  end
end
