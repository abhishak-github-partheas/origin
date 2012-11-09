class SubjectsController < ApplicationController

  layout 'admin'

  def index
    list
    render('list')
  end	

  def list
    #Subject.all
    @subjects = Subject.order("subjects.id ASC")
    flash[:notice] = "List of Subjects"
  end	

  def show
  	@subject = Subject.find(params[:id]) 
  end	

  def new
  	@subject = Subject.new
  end	

  def create
  	#Instantiate a new object using form parameters
  	@subject = Subject.new(params[:subject])
  	#save the eobject
  	if @subject.save
  	  #if save succeeds, redirect to the list action.
      flash[:notice] = "Subject Created"
  	  redirect_to(:action => 'list')
  	else  
  	  # if save fails, redisplay the form so user can fix problems
  	  render('new')
  	end  
  end	
 
  def edit
    @subject = Subject.find(params[:id])
  end  

  def update
    #Find object using form parameters
    @subject = Subject.find(params[:id])
    #update the object
    if @subject.update_attributes(params[:subject])
      #if update succeeds, redirect to the list action.
      flash[:notice] = "Subject Updated"
      redirect_to(:action => 'show', :id => @subject.id)
    else  
      # if save fails, redisplay the form so user can fix problems
      render('edit')
    end    
  end  

  def delete
    @subject = Subject.find(params[:id])
  end
  
  def destroy
    @subject = Subject.find(params[:id])
    flash[:notice] = "Subject destroyed"
    @subject.destroy
    redirect_to(:action => 'list')
  end  
end