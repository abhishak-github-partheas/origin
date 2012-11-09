class DemoController < ApplicationController
  
  layout 'admin'

  def index
  	#redirect_to(:action => 'other_hello')
  end

  def hello
  	#render(:text => 'Hello Everyone!')
  	#redirect_to('http://www.google.com')
  	@array = [1,2,3,4,5]
  	@id = params[:id]
  	@page = params[:page]
  end
  	
  def other_hello
  	render(:text => 'Hello Everyone!')
  end	

  def javascript
    
  end  
end
