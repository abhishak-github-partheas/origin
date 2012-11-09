class Subject < ActiveRecord::Base
  
  attr_accessible :sub_first_name, :sub_last_name, :created_at, :updated_at
  has_many :pages
  # attr_accessible :title, :body
end
