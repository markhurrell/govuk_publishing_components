module GovukPublishingComponents
  module Presenters
    class BreadcrumbsBasedOnParent
      def initialize(content_item)
        @content_item = content_item
      end

      def breadcrumbs
        ordered_parents = all_parents.map do |parent|
          { title: parent.fetch("title"), url: parent.fetch("base_path") }
        end

        ordered_parents << { title: "Home", url: "/" }

        ordered_parents.reverse
      end

    private

      attr_reader :content_item

      def all_parents
        parents = []

        direct_parent = content_item.dig("links", "parent", 0)
        while direct_parent
          parents << direct_parent

          direct_parent = direct_parent.dig("links", "parent", 0)
        end

        parents
      end
    end
  end
end
