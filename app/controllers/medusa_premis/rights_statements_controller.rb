class MedusaPremis::RightsStatementsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  # GET /medusa_premis/rights_statements
  # GET /medusa_premis/rights_statements.json
  def index
    @medusa_premis_rights_statements = MedusaPremis::RightsStatement.all

    respond_to do |format|
      format.html {setup_next_and_previous_documents} # index.html.erb
      format.json { render json: @medusa_premis_rights_statements }
    end
  end

  # GET /medusa_premis/rights_statements/1
  # GET /medusa_premis/rights_statements/1.json
  def show
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medusa_premis_rights_statement }
    end
  end

  # GET /medusa_premis/rights_statements/new
  # GET /medusa_premis/rights_statements/new.json
  def new
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medusa_premis_rights_statement }
    end
  end

  # GET /medusa_premis/rights_statements/1/edit
  def edit
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @medusa_premis_rights_statement }
    end

  end

  # POST /medusa_premis/rights_statements
  # POST /medusa_premis/rights_statements.json
  def create
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.new(params[:medusa_premis_rights_statement])

    respond_to do |format|
      if @medusa_premis_rights_statement.save
        format.html { redirect_to(catalog_path(id: @medusa_premis_rights_statement.id), notice: 'Rights statement was successfully created.') }
        format.json { render json: @medusa_premis_rights_statement, status: :created, location: @medusa_premis_rights_statement }
      else
        format.html { render action: "new" }
        format.json { render json: @medusa_premis_rights_statement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.find(params[:id])
    respond_to do |format|
     if @medusa_premis_rights_statement.update_attributes(params[:medusa_premis_rights_statement])
       format.html { redirect_to(catalog_path(id: params[:id]), notice: 'Rights statement was successfully updated.') }
       format.json { head :no_content }
     else
       format.html { render action: "edit" }
       format.json { render json: @medusa_premis_rights_statement.errors, status: :unprocessable_entity }
     end
   end
  end

  # DELETE /medusa_premis/rights_statements/1
  # DELETE /medusa_premis/rights_statements/1.json
  def destroy
    @medusa_premis_rights_statement = MedusaPremis::RightsStatement.find(params[:id])
    @medusa_premis_rights_statement.destroy

    respond_to do |format|
      format.html {
        query_params = session[:search] ? session[:search].dup : {}
        query_params.delete :counter
        query_params.delete :total
        link_url = url_for(query_params)
        redirect_to(link_url, notice: 'Rights statement was successfully deleted.') }
      format.json { head :no_content }
    end
  end
end
