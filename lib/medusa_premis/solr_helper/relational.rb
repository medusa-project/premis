module MedusaPremis::SolrHelper::Relational
  extend ActiveSupport::Concern
  include Blacklight::SolrHelper

  # def self.included base
  #   base.solr_search_params_logic << :show_rels_ext_records
  # end

  # solr_search_params_logic methods take two arguments
  # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
  # @param [Hash] user_parameters a hash of user-supplied parameters (often via `params`)

  # NOTE:  q is NOT changed and IS ASSUMED to be an id... but the parameter sent to solr IS CHANGED (to an internal_uri)
  def show_rels_ext_records solr_parameters, user_parameters
    # Determine kind of search
    search = false

    if ( user_parameters.key?("search_field") and (!user_parameters[:q].nil?) and (user_parameters[:search_field] == "related to"))
      # Basic blacklight search for rels_ext of id
      search = true
      q = user_parameters[:q]
      type_of_search = "related to"
    end

    if ( user_parameters.key?("related to") and !user_parameters['related to'].nil? and !user_parameters['related to'].empty? )
      # Advanced blacklight search for rels_ext of id
      search = true
      q = user_parameters['related to']
      type_of_search = "related to"
    end

    if (search)
      # this is a related search, so "q" is the id that we will find in solr, which is really now an internal_uri converted from RELS-EXT
      id = MedusaPremis::General.return_uri(q)

      # what to do if nil??... skip adding solr parsm... otherwise, it will pick everything

      # add internal_uri.... to actual id (which won't find anything... and there's no need to get rid of)
      if (!id.nil?)
        solr_parameters[:q] = "\{!qf=$related_to_qf pf=$related_to_pf\}#{id}"
      end
    end
  end
end