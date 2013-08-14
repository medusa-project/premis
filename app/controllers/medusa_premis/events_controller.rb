class MedusaPremis::EventsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  # GET /medusa_premis/events
  # GET /medusa_premis/events.json
  def index
    @medusa_premis_events = MedusaPremis::Event.all

    respond_to do |format|
      format.html {setup_next_and_previous_documents} # index.html.erb
      format.json { render json: @medusa_premis_events }
    end
  end

  # GET /medusa_premis/events/1
  # GET /medusa_premis/events/1.json
  def show
    @medusa_premis_event = MedusaPremis::Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medusa_premis_event }
    end
  end

  # GET /medusa_premis/events/new
  # GET /medusa_premis/events/new.json
  def new
    @medusa_premis_event = MedusaPremis::Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medusa_premis_event }
    end
  end

  # GET /medusa_premis/events/1/edit
  def edit
    @medusa_premis_event = MedusaPremis::Event.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @medusa_premis_event }
    end

  end

  # POST /medusa_premis/events
  # POST /medusa_premis/events.json
  def create
    @medusa_premis_event = MedusaPremis::Event.new(params[:medusa_premis_event])

    respond_to do |format|
      if @medusa_premis_event.save
        format.html { redirect_to(catalog_path(id: @medusa_premis_event.id), notice: 'Event was successfully created.') }
        format.json { render json: @medusa_premis_event, status: :created, location: @medusa_premis_event }
      else
        format.html { render action: "new" }
        format.json { render json: @medusa_premis_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @medusa_premis_event = MedusaPremis::Event.find(params[:id])
    respond_to do |format|
     if @medusa_premis_event.update_attributes(params[:medusa_premis_event])
       format.html { redirect_to(catalog_path(id: params[:id]), notice: 'Event was successfully updated.') }
       format.json { head :no_content }
     else
       format.html { render action: "edit" }
       format.json { render json: @medusa_premis_event.errors, status: :unprocessable_entity }
     end
   end
  end

  # DELETE /medusa_premis/events/1
  # DELETE /medusa_premis/events/1.json
  def destroy
    @medusa_premis_event = MedusaPremis::Event.find(params[:id])
    @medusa_premis_event.destroy

    respond_to do |format|
      format.html {
        query_params = session[:search] ? session[:search].dup : {}
        query_params.delete :counter
        query_params.delete :total
        link_url = url_for(query_params)
        redirect_to(link_url, notice: 'Event was successfully deleted.') }
      format.json { head :no_content }
    end
  end
end
