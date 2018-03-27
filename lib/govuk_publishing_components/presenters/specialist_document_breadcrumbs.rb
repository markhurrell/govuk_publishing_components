module GovukPublishingComponents
  module Presenters
    class SpecialistDocumentBreadcrumbs
      def initialize(content_item)
        @content_item = content_item
      end

      def breadcrumbs
        parent_finder = content_item.dig("links", "finder", 0)
        return [] unless parent_finder

        [
          {
            title: "Home",
            url: "/",
          },
          {
            title: parent_finder['title'],
            url: parent_finder['base_path'],
          }
        ]
      end
    end
  end
end
