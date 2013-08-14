class MedusaPremis::AgentsController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  # GET /medusa_premis/agents
  # GET /medusa_premis/agents.json
  def index
    @medusa_premis_agents = MedusaPremis::Agent.all

    respond_to do |format|
      format.html {setup_next_and_previous_documents} # index.html.erb
      format.json { render json: @medusa_premis_agents }
    end
  end

  # GET /medusa_premis/agents/1
  # GET /medusa_premis/agents/1.json
  def show
    @medusa_premis_agent = MedusaPremis::Agent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medusa_premis_agent }
    end
  end

  # GET /medusa_premis/agents/new
  # GET /medusa_premis/agents/new.json
  def new
    @medusa_premis_agent = MedusaPremis::Agent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medusa_premis_agent }
    end
  end

  # GET /medusa_premis/agents/1/edit
  def edit
    @medusa_premis_agent = MedusaPremis::Agent.find(params[:id])

    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @medusa_premis_agent }
    end

  end

  # POST /medusa_premis/agents
  # POST /medusa_premis/agents.json
  def create
    @medusa_premis_agent = MedusaPremis::Agent.new(params[:medusa_premis_agent])

    respond_to do |format|
      if @medusa_premis_agent.save
        format.html { redirect_to(catalog_path(id: @medusa_premis_agent.id), notice: 'Agent was successfully created.') }
        format.json { render json: @medusa_premis_agent, status: :created, location: @medusa_premis_agent }
      else
        format.html { render action: "new" }
        format.json { render json: @medusa_premis_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @medusa_premis_agent = MedusaPremis::Agent.find(params[:id])
    respond_to do |format|
     if @medusa_premis_agent.update_attributes(params[:medusa_premis_agent])
       format.html { redirect_to(catalog_path(id: params[:id]), notice: 'Agent was successfully updated.') }
       format.json { head :no_content }
     else
       format.html { render action: "edit" }
       format.json { render json: @medusa_premis_agent.errors, status: :unprocessable_entity }
     end
   end
  end

  # DELETE /medusa_premis/agents/1
  # DELETE /medusa_premis/agents/1.json
  def destroy
    @medusa_premis_agent = MedusaPremis::Agent.find(params[:id])
    @medusa_premis_agent.destroy

    respond_to do |format|
      format.html {
        query_params = session[:search] ? session[:search].dup : {}
        query_params.delete :counter
        query_params.delete :total
        link_url = url_for(query_params)
        redirect_to(link_url, notice: 'Agent was successfully deleted.') }
      format.json { head :no_content }
    end
  end
end
