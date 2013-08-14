# -*- encoding : utf-8 -*-
class SolrDocument 

  include Blacklight::Solr::Document

  # self.unique_key = 'id'
  
  # The following shows how to setup this blacklight document to display marc documents
  extension_parameters[:marc_source_field] = :marc_display
  extension_parameters[:marc_format_type] = :marcxml
  use_extension( Blacklight::Solr::Document::Marc) do |document|
    document.key?( :marc_display  )
  end
  
  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Email )
  
  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Solr::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Solr::Document::ExtendableClassMethods#field_semantics
  # and Blacklight::Solr::Document#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Solr::Document::DublinCore)    
  field_semantics.merge!(    
                         :title => "title_display",
                         :author => "author_display",
                         :language => "language_facet",
                         :format => "format"
                         )

  def to_medusa_premis_edit
    type = get_medusa_premis_entity_name
    case
      when type.match(/Rights Statement/i)
        return "edit_medusa_premis_rights_statement_path"
      when type.match(/Agent/i)
        return "edit_medusa_premis_agent_path"
      when type.match(/Event/i)
        return 'edit_medusa_premis_event_path'
      when type.match(/File Object/i)
        return 'edit_medusa_premis_file_object_path'
      when type.match(/Representation Object/i)
        return 'edit_medusa_premis_representation_object_path'
      else
        return 'unknown_path'
    end
  end

  def to_medusa_premis_destroy
    type = get_medusa_premis_entity_name
    case
      when type.match(/Rights Statement/i)
        return "medusa_premis_rights_statement_path"
      when type.match(/Agent/i)
        return "medusa_premis_agent_path"
      when type.match(/Event/i)
        return 'medusa_premis_event_path'
      when type.match(/File Object/i)
        return 'medusa_premis_file_object_path'
      when type.match(/Representation Object/i)
        return 'medusa_premis_representation_object_path'
      else
        return 'unknown_path'
    end
  end

  def to_medusa_premis_create
    type = get_medusa_premis_entity_name
    case
      when type.match(/Rights Statement/i)
        return "new_medusa_premis_rights_statement_path"
      when type.match(/Agent/i)
        return "new_medusa_premis_agent_path"
      when type.match(/Event/i)
        return 'new_medusa_premis_event_path'
      when type.match(/File Object/i)
        return 'new_medusa_premis_file_object_path'
      when type.match(/Representation Object/i)
        return 'new_medusa_premis_representation_object_path'
      else
        return 'unknown_path'
    end
  end

  protected

  # get premis record entity name from solrDocument's active_fedora_model.
  def get_medusa_premis_entity_name
    @_source = self.with_indifferent_access
    model = @_source['active_fedora_model_ssim'].first
    case
      when model.match(/MedusaPremis\:\:RightsStatement/i)
        return "Rights Statement"
      when model.match(/MedusaPremis\:\:Agent/i)
        return "Agent"
      when model.match(/MedusaPremis\:\:Event/i)
        return 'Event'
      when model.match(/MedusaPremis\:\:FileObject/i)
        return 'File Object'
      when model.match(/MedusaPremis\:\:RepresentationObject/i)
        return 'Representation Object'
      else
        return 'Unknown'
    end
  end


end
