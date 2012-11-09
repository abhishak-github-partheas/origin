class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string "page number"
      t.string "page_quality"
      t.timestamps
    end
  end
end
