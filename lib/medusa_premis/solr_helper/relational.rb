module MedusaPremis::SolrHelper::Relational
  extend ActiveSupport::Concern
  include Blacklight::SolrHelper

  # def self.included base
  #   base.solr_search_params_logic << :show_rels_ext_records
  # end

  # solr_search_params_logic methods take two arguments
  # @param [Hash] solr_parameters a hash of parameters to be sent to Solr (via RSolr)
  # @param [Hash] user_parameters a hash of user-supplied parameters (often via `params`)
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
      results = MedusaPremis::General.ids_or_file(q, type_of_search)

      if (results[:type] == "ids")
        # convert array of ids to fq statement
        if (results[:ids_entity].nil?)
          # force to return nothing
          fq = "-id:*"
        else
          fq_value =  results[:ids_entity].map { |c| '"' + c.to_s + '"' }.join(" OR ")
          fq = "id:(#{fq_value})"
        end
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << fq
      else
        # file type
        solr_parameters[:fl] = ["*, score, relate:field(#{results[:ids_entity]})"]
        # sort first by 'relate'...
        solr_parameters[:sort] = "{!func}#{results[:ids_entity]} desc, " + solr_parameters[:sort]
      end
    end
  end
end