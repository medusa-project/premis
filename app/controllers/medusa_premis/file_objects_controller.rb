class MedusaPremis::FileObjectsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  # GET /medusa_premis/file_objects
  # GET /medusa_premis/file_objects.json
  def index
    @medusa_premis_file_objects = MedusaPremis::FileObject.all

    respond_to do |format|
      format.html {setup_next_and_previous_documents} # index.html.erb
      format.json { render json: @medusa_premis_file_objects }
    end
  end

  # GET /medusa_premis/file_objects/1
  # GET /medusa_premis/file_objects/1.json
  def show
    @medusa_premis_file_object = MedusaPremis::FileObject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medusa_premis_file_object }
    end
  end

  # GET /medusa_premis/file_objects/new
  # GET /medusa_premis/file_objects/new.json
  def new
    @medusa_premis_file_object = MedusaPremis::FileObject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medusa_premis_file_object }
    end
  end

  # GET /medusa_premis/file_objects/1/edit
  def edit
    @medusa_premis_file_object = MedusaPremis::FileObject.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @medusa_premis_file_object }
    end

  end

  # POST /medusa_premis/file_objects
  # POST /medusa_premis/file_objects.json
  def create
    @medusa_premis_file_object = MedusaPremis::FileObject.new(params[:medusa_premis_file_object])

    respond_to do |format|
      if @medusa_premis_file_object.save
        format.html { redirect_to(catalog_path(id: @medusa_premis_file_object.id), notice: 'File object was successfully created.') }
        format.json { render json: @medusa_premis_file_object, status: :created, location: @medusa_premis_file_object }
      else
        format.html { render action: "new" }
        format.json { render json: @medusa_premis_file_object.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @medusa_premis_file_object = MedusaPremis::FileObject.find(params[:id])
    respond_to do |format|
     if @medusa_premis_file_object.update_attributes(params[:medusa_premis_file_object])
       format.html { redirect_to(catalog_path(id: params[:id]), notice: 'File object was successfully updated.') }
       format.json { head :no_content }
     else
       format.html { render action: "edit" }
       format.json { render json: @medusa_premis_file_object.errors, status: :unprocessable_entity }
     end
   end
  end

  # DELETE /medusa_premis/file_objects/1
  # DELETE /medusa_premis/file_objects/1.json
  def destroy
    @medusa_premis_file_object = MedusaPremis::FileObject.find(params[:id])
    @medusa_premis_file_object.destroy

    respond_to do |format|
      format.html {
        query_params = session[:search] ? session[:search].dup : {}
        query_params.delete :counter
        query_params.delete :total
        link_url = url_for(query_params)
        redirect_to(link_url, notice: 'File object was successfully deleted.') }
      format.json { head :no_content }
    end
  end

  # GET /medusa_premis/file_objects/1/show_object
  def show_object
    @medusa_premis_file_object = MedusaPremis::FileObject.find(params[:id])

    @full_url_of_object = @medusa_premis_file_object.inner_object.repository.config[:url] + '/' + @medusa_premis_file_object.datastreams['content'].url

    # go directly to url
    redirect_to @full_url_of_object

    # respond_to do |format|
    #   format.html # show.html.erb
    # end
  end

end
