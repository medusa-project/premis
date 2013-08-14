# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include MedusaPremis::SolrHelper::Relational
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  # These before_filters apply the hydra access controls
 #   before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
 # CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]
  # CatalogController.solr_search_params_logic += [:show_rels_ext_records]


  configure_blacklight do |config|
    config.default_solr_params = { 
      # :qf defaults to show fields that are automatically displayed in index results... see 'search' handler in solrconfig.xml
      :qt => 'search',
      :rows => 10 
    }

    # solr field configuration for search results/index views
    # config.index.show_link = 'id'
    # config.index.record_tsim_type = 'has_model_ssim'

    # config.index.show_link = 'title_tesim'
    # config.index.record_tsim_type = 'has_model_ssim'

    # solr field configuration for document/show views
    # config.show.html_title = 'title_tesim'
    # config.show.heading = 'title_tesim'
    # config.show.display_type = 'has_model_ssim'
    config.show.display_type = "active_fedora_model_ssim"

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _tsimed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    config.add_facet_field solr_name('premis_model_facet', :facetable), :label => 'Premis Model'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys

    dating = Solrizer::Descriptor.new(:date, :stored, :indexed)
    # dating = Solrizer::Descriptor.new(:date, :stored, :indexed, converter: Solrizer::Descriptor::dateable_converter)

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name('active_fedora_model', :symbol), :label => 'Record Type', :helper_method => :display_medusa_premis_record_type
    config.add_index_field solr_name('system_create', dating), :label => 'Creation Date', :date => { :format => :DateField }
    config.add_index_field solr_name('system_modified', dating), :label => 'Modified Date', :date => { :format => :DateField }
    config.add_index_field solr_name('identifierType', :stored_searchable), :label => 'Identifier Type'
    config.add_index_field solr_name('identifierValue', :stored_searchable), :label => 'Identifier Value'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display

    #   Common before:
    config.add_show_field solr_name('identifierType', :stored_searchable, type: :string), :label => 'Identifier Type:'
    config.add_show_field solr_name('identifierValue', :stored_searchable, type: :string), :label => 'Identifier Value:'

    # For Premis Rights Statement:
    config.add_show_field solr_name('rightsStatementCopyrightStatus', :stored_searchable, type: :string), :label => 'Copyright Status:'
    config.add_show_field solr_name('rightsStatementCopyrightJurisdiction', :stored_searchable, type: :string), :label => 'Copyright Jurisdiction:'
    config.add_show_field solr_name('rightsStatementLinkingObjectIdentifierType_GrantedAct', :stored_searchable, type: :string), :label => 'Granted Act:'
    config.add_show_field solr_name('rightsStatementGrantedRestriction', :stored_searchable, type: :string), :label => 'Granted Restriction:'

    # For Premis Agent:
    config.add_show_field solr_name('agentName', :stored_searchable, type: :string), :label => 'Agent Name:'
    config.add_show_field solr_name('agentNote', :stored_searchable, type: :string), :label => 'Note:'
    config.add_show_field solr_name('agentExtension', :stored_searchable, type: :string), :label => 'Extension:'
    config.add_show_field solr_name('agentType', :stored_searchable, type: :string), :label => 'Agent Type:'

    # for Premis Event:
    config.add_show_field solr_name('eventType', :stored_searchable, type: :string), :label => 'Event Type:'
    config.add_show_field solr_name('eventDateTime', :stored_searchable, type: :string), :label => 'Date and Time:'
    config.add_show_field solr_name('eventDetail', :stored_searchable, type: :string), :label => 'Detail:'
    config.add_show_field solr_name('eventOutcome', :stored_searchable, type: :string), :label => 'Outcome:'
    config.add_show_field solr_name('eventOutcomeDetailNote', :stored_searchable, type: :string), :label => 'Outcome Detail:'
    config.add_show_field solr_name('eventOutcomeDetailExtension', :stored_searchable, type: :string), :label => 'Outcome Detail Extension:'

    # for Related To:
    config.add_show_field solr_name('linkingEvent', :stored_searchable, type: :string), :label => 'Linked Event:'

    # Common after:
    config.add_show_field solr_name('linkingEventIdentifierType', :stored_searchable, type: :string), :label => 'Linked Event Ident Type:'
    config.add_show_field solr_name('linkingEventIdentifierValue', :stored_searchable, type: :string), :label => 'Linked Event Ident Value:'
    config.add_show_field solr_name('linkingRightsStatementIdentifierType', :stored_searchable, type: :string), :label => 'Linked Rights Ident Type:'
    config.add_show_field solr_name('linkingRightsStatementIdentifierValue', :stored_searchable, type: :string), :label => 'Linked Rights Ident Value:'
    config.add_show_field solr_name('linkingObjectIdentifierType', :stored_searchable, type: :string), :label => 'Linked Object Ident Type:'
    config.add_show_field solr_name('linkingObjectIdentifierValue', :stored_searchable, type: :string), :label => 'Linked Object Ident Value:'
    config.add_show_field solr_name('linkingObjectRole', :stored_searchable, type: :string), :label => 'Linked Object Role:'
    config.add_show_field solr_name('linkingAgentIdentifierType', :stored_searchable, type: :string), :label => 'Linked Agent Ident Type:'
    config.add_show_field solr_name('linkingAgentIdentifierValue', :stored_searchable, type: :string), :label => 'Linked Agent Ident Value:'
    config.add_show_field solr_name('linkingAgentRole', :stored_searchable, type: :string), :label => 'Linked Agent Role:'


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    config.add_search_field 'all_fields', :label => 'All Fields'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 

    config.add_search_field('agent') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      # field.solr_parameters = { :'spellcheck.dictionary' => 'agent' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$agent_qf }. This is neccesary to use
      # Solr parameter de-referencing like $agent_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
          :qf => '$agent_qf',
          :pf => '$agent_pf'
      }
    end

    config.add_search_field('event') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      # field.solr_parameters = { :'spellcheck.dictionary' => 'event' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$event_qf }. This is neccesary to use
      # Solr parameter de-referencing like $event_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
          :qf => '$event_qf',
          :pf => '$event_pf'
      }
    end

    config.add_search_field('rights statement') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      # field.solr_parameters = { :'spellcheck.dictionary' => 'rights_statement' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$rights_statement_qf }. This is neccesary to use
      # Solr parameter de-referencing like $rights_statement_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
          :qf => '$rights_statement_qf',
          :pf => '$rights_statement_pf'
      }
    end

    config.add_search_field('related to') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      # field.solr_parameters = { :'spellcheck.dictionary' => 'related_to' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$related_to_qf }. This is neccesary to use
      # Solr parameter de-referencing like $related_to_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
          :qf => '$related_to_qf',
          :pf => '$related_to_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, system_create_dtsi desc, id asc', :label => 'relevance'
    config.add_sort_field 'system_modified_dtsi desc, system_create_dtsi desc', :label => 'modified date'
    config.add_sort_field 'system_create_dtsi desc, system_modified_dtsi desc', :label => 'creation date'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end



end 
