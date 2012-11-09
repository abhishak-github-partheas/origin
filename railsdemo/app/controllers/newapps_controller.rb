class NewappsController < ApplicationController
  # GET /newapps
  # GET /newapps.json
  def index
    @newapps = Newapp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @newapps }
    end
  end

  # GET /newapps/1
  # GET /newapps/1.json
  def show
    @newapp = Newapp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @newapp }
    end
  end

  # GET /newapps/new
  # GET /newapps/new.json
  def new
    @newapp = Newapp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @newapp }
    end
  end

  # GET /newapps/1/edit
  def edit
    @newapp = Newapp.find(params[:id])
  end

  # POST /newapps
  # POST /newapps.json
  def create
    @newapp = Newapp.new(params[:newapp])

    respond_to do |format|
      if @newapp.save
        format.html { redirect_to @newapp, notice: 'Newapp was successfully created.' }
        format.json { render json: @newapp, status: :created, location: @newapp }
      else
        format.html { render action: "new" }
        format.json { render json: @newapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /newapps/1
  # PUT /newapps/1.json
  def update
    @newapp = Newapp.find(params[:id])

    respond_to do |format|
      if @newapp.update_attributes(params[:newapp])
        format.html { redirect_to @newapp, notice: 'Newapp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @newapp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newapps/1
  # DELETE /newapps/1.json
  def destroy
    @newapp = Newapp.find(params[:id])
    @newapp.destroy

    respond_to do |format|
      format.html { redirect_to newapps_url }
      format.json { head :no_content }
    end
  end
end
