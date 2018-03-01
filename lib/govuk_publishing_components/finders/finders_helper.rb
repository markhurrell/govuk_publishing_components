module FindersHelper
  UPPERCASE_POLICY_AREA_PREFIXES = %w(
    Europe
    National Health Service
    Northern Ireland
    Scotland
    UK
    Wales
  ).freeze

  STATISTICS_DOCTYPES = %w(national_statistics official_statistics).freeze

  NAV_TYPES = {
    "announcements" => ["fatality_notice", "news_article", "speech", "world_location_news_article"],
    "publications" => ["consultation", "publication"],
    "specialist_document" => ["specialist_document"],
    "statistics" => ["statistical_data_set", "statistics_announcement"]
  }

  ANNOUNCEMENT_DOCUMENT_TYPE_MAPPINGS = {
    "fatality_notice" => "fatality-notices",
    "news_story" => "news-stories",
  }.freeze

  def finder_link_text
    buf = ["More #{pluralised_document_type}"]
    return buf.first if specialist_document?
    buf << "about #{policy_area_name}" if policy_area_name
    buf << "from #{publishing_organisation}"
    buf.join(" ")
  end

  def pluralised_document_type
    return "statistics_announcements" if statistics_announcement?
    return "Statistics" if statistics_announcement?
    return "FOI releases" if document_type == "foi_release"

    doctype = I18n.t("@content_item.schema_name.#{document_type}", count: 2, locale: :en)

    unless specialist_document?
      doctype[0] = doctype[0].downcase
    end
    doctype
  end

  def statistics_announcement?
    @content_item["schema_name"] == "statistics_announcement"
  end

  def specialist_document?
    @content_item["schema_name"] == "specialist_document"
  end

  def statistics_document_type?
    STATISTICS_DOCTYPES.include?(document_type)
  end

  def policy_area_name
    name = link_titles("policy_areas").first
    return unless name
    name.downcase! unless name.start_with?(*UPPERCASE_POLICY_AREA_PREFIXES)
    name
  end

  def publishing_organisation
    link_titles("primary_publishing_organisation").first ||
      link_titles("organisations").first
  end

  def link_titles(link_type)
    link_group(link_type).map { |l| l["title"] }
  end

  def finder_path_and_params
    return "/government/announcements?#{announcements_facet_params}" if announcement?
    return "/government/publications?#{publication_facet_params}" if publication?
    return "#{specialist_document_finder_path}?#{specialist_document_facet_params}" if specialist_document?
    return "/government/#{statistics_finder_path}?#{statistics_facet_params}" if statistics?
  end

  def announcements_facet_params
    departments.merge(filter_option("announcement")).merge(topics).to_query
  end

  def publication_facet_params
    departments.merge(filter_option("publication")).merge(topics).to_query
  end

  def specialist_document_facet_params
    @content_item["details"]["metadata"]
      .each_value { |v| v.try(:sort!) }
      .except(*params_to_ignore)
      .to_query
  end

  def statistics_facet_params
    departments.merge(topics).to_query
  end

  def specialist_document_finder_path
    finder["base_path"] if finder
  end

  def statistics_finder_path
    path = "statistics"
    path += "/announcements" if statistics_announcement?
    path
  end

  def params_to_ignore
    %w(bulk_published) + date_facet_keys
  end

  def date_facet_keys
    return [] unless finder
    finder_details = finder.fetch("details", {})
    finder_details.fetch("facets", {}).map { |f| f["key"] if f["type"] == "date" }.compact
  end

  def finder
    finders = @content_item["links"]["finder"]
    finders.first
  end

  def departments
    multiple_options_from_links("organisations", "departments")
  end

  def multiple_options_from_links(link_type, option_key = nil)
    option_key ||= link_type

    options = link_group(link_type).map { |l| option_value(l) }
    options = %w(all) if options.empty?

    { option_key => options }
  end

  def option_value(link)
    if link["schema_name"] == "world_location"
      link["title"].parameterize
    else
      link["base_path"].split("/").last
    end
  end

  def filter_option(nav_type)
    option = @content_item["government_document_supertype"]
    option ||= ANNOUNCEMENT_DOCUMENT_TYPE_MAPPINGS.fetch(document_type, "all")
    { "#{nav_type}_filter_option" => option }
  end

  def topics
    multiple_options_from_links("policy_areas", "topics")
  end

  def announcement?
    NAV_TYPES["announcements"].include?(schema_name)
  end

  def publication?
    NAV_TYPES["publications"].include?(schema_name)
  end

  def statistics?
    NAV_TYPES["statistics"].include?(schema_name)
  end

  def schema_name
    @content_item["schema_name"]
  end
end
