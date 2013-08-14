module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    "Medusa-premis Administration"
  end

  # Return a normalized partial name that can be used to contruct view partial path
  def document_partial_name(document)
    # .to_s is necessary otherwise the default return value is not always a string
    # using "_" as sep. to more closely follow the views file naming conventions
    # parameterize uses "-" as the default sep. which throws errors
    display_type = document[blacklight_config.show.display_type]

    return 'default' unless display_type

    display_type = display_type.join(" ") if display_type.respond_to?(:join)

    # display_type should be only ONE record and NOT fedora model... and is in following format: MedusaPremis::xxx, where xxx is partial name
    #    It should end up underscored, not camel-cased
    display_type = display_type.split("::").last.underscore

    "#{display_type.gsub("-"," ")}".parameterize("_").to_s
  end

  # link_to_document(doc, :label=>'VIEW', :counter => 3)
  # Use the catalog_path RESTful route to create a link to the show page for a specific item.
  # catalog_path accepts a HashWithIndifferentAccess object. The solr query params are stored in the session,
  # so we only need the +counter+ param here. We also need to know if we are viewing to document as part of search results.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    opts[:label] ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts

    # WE must get to proper route so comment out doc-- solr document which defaults to id
    link_to label, doc, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    # name = document_partial_name(doc)
    # url = "medusa_premis/" + name.pluralize + "/" + doc.id
    # link_to label, url, { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k })
  end

end
