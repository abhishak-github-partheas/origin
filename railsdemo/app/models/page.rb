class Page < ActiveRecord::Base
  
  attr_accessible :page_number, :page_quality
  
  belongs_to :subject
  #has_many :sections
  has_and_belongs_to_many :users

  # attr_accessible :title, :body
end
