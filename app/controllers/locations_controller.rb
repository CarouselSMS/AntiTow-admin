class LocationsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_to_index
  
  # Shows the list of all locations
  def index
    @locations = Location.all
  end
  
  # Shows the location details
  def show
    @location = Location.find(params[:id])
  end
  
  # New location form
  def new
    @location = Location.new
  end
  
  # Creates new location
  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "Location record was created"
      redirect_to locations_url
    else
      render "new"
    end
  end
  
  # Edit location form
  def edit
    @location = Location.find(params[:id])
  end
  
  # Updates location
  def update
    @location = Location.find(params[:id])
    
    # Reset timestamps and cached calendar in case of the feed URL change
    if params[:location][:feed_url] != @location.feed_url
      params[:location][:checked_at]      = Time.now
      params[:location][:feed_updated_at] = nil
      params[:location][:vcalendar]       = nil
    end
    
    if @location.update_attributes(params[:location])
      flash[:notice] = "Location record was updated"
      redirect_to location_url(@location)
    else
      render "edit"
    end
  end
  
  # Destroys location
  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to locations_url
  end

  private
  
  # Redirects to the locations list
  def redirect_to_index
    redirect_to locations_url
  end
end
