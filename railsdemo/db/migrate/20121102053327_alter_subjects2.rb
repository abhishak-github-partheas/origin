  def up
  	add_column("subjects", "sub_first_name", :string)
  	add_column("subjects", "sub_last_name", :string)
  end

  def down
  end
end
