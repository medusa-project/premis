module ApplicationHelper

  def display_medusa_premis_record_type args
    # arguments are :document (solrDocument object) and :field (solr field to display)
    model = args[:document][args[:field]].first
    case
      when model.match(/MedusaPremis\:\:RightsStatement/i)
        return 'Rights Statement'
      when model.match(/MedusaPremis\:\:Agent/i)
        return 'Agent'
      when model.match(/MedusaPremis\:\:Event/i)
        return 'Event'
      when model.match(/MedusaPremis\:\:FileObject/i)
        return 'File Object'
      when model.match(/MedusaPremis\:\:RepresentationObject/i)
        return 'Representation Object'
      else
        return 'Unknown Record Type'
    end
  end

  def display_relation_catalog_index args
    related_id = args[:related_id]
    id = args[:id]

    if (id.nil?)
      return nil
    end

    relation = MedusaPremis::General.get_relations_from_fedora(id, related_id)
    if (!relation.nil?)
      "<dt class=\"MedusaPremis-relation\">Relation</dt>
       <dd class=\"MedusaPremis-relation\">#{relation}</dd>".html_safe
    end
  end

  def link_for_related_to_search args
    related_id = args[:related_id]

    query_params = session[:search] ? session[:search].dup : {}
    query_params.delete :counter
    query_params.delete :total

    # if advanced search
    if ( !params[:search_field].nil? and (params[:search_field] == "advanced"))
      query_params['related to'] = related_id
    else
      # basic search & wipe out was already searched...
      query_params[:search_field] = "related to"
      query_params[:q] = related_id
    end

    link_url = url_for(query_params)
    return link_url
  end

  def get_search_id
    id = nil
    if ( !params[:search_field].nil? and (!params[:q].nil?) and (params[:search_field] == "related to"))
      # Basic blacklight search for rels_ext of id
      id = params["q"]
    end

    if ( !params['related to'].nil? and !params['related to'].empty? )
      # Advanced blacklight search for rels_ext of id
      id = params['related to']
    end
    return id
  end
end
