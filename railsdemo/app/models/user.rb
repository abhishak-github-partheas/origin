class User < ActiveRecord::Base

	has_and_belongs_to_many :pages
  # attr_accessible :title, :body
end
