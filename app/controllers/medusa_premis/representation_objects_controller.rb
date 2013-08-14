class MedusaPremis::RepresentationObjectsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  # GET /medusa_premis/representation_objects
  # GET /medusa_premis/representation_objects.json
  def index
    @medusa_premis_representation_objects = MedusaPremis::RepresentationObject.all

    respond_to do |format|
      format.html {setup_next_and_previous_documents} # index.html.erb
      format.json { render json: @medusa_premis_representation_objects }
    end
  end

  # GET /medusa_premis/representation_objects/1
  # GET /medusa_premis/representation_objects/1.json
  def show
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medusa_premis_representation_object }
    end
  end

  # GET /medusa_premis/representation_objects/new
  # GET /medusa_premis/representation_objects/new.json
  def new
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medusa_premis_representation_object }
    end
  end

  # GET /medusa_premis/representation_objects/1/edit
  def edit
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @medusa_premis_representation_object }
    end

  end

  # POST /medusa_premis/representation_objects
  # POST /medusa_premis/representation_objects.json
  def create
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.new(params[:medusa_premis_representation_object])

    respond_to do |format|
      if @medusa_premis_representation_object.save
        format.html { redirect_to(catalog_path(id: @medusa_premis_representation_object.id), notice: 'Representation object was successfully created.') }
        format.json { render json: @medusa_premis_representation_object, status: :created, location: @medusa_premis_representation_object }
      else
        format.html { render action: "new" }
        format.json { render json: @medusa_premis_representation_object.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.find(params[:id])
    respond_to do |format|
     if @medusa_premis_representation_object.update_attributes(params[:medusa_premis_representation_object])
       format.html { redirect_to(catalog_path(id: params[:id]), notice: 'Representation object was successfully updated.') }
       format.json { head :no_content }
     else
       format.html { render action: "edit" }
       format.json { render json: @medusa_premis_representation_object.errors, status: :unprocessable_entity }
     end
   end
  end

  # DELETE /medusa_premis/representation_objects/1
  # DELETE /medusa_premis/representation_objects/1.json
  def destroy
    @medusa_premis_representation_object = MedusaPremis::RepresentationObject.find(params[:id])
    @medusa_premis_representation_object.destroy

    respond_to do |format|
      format.html {
        query_params = session[:search] ? session[:search].dup : {}
        query_params.delete :counter
        query_params.delete :total
        link_url = url_for(query_params)
        redirect_to(link_url, notice: 'Representation object was successfully deleted.') }
      format.json { head :no_content }
    end
  end
end
