module GovukPublishingComponents
  module Presenters
    # @private
    class WhatToShow
      GUIDANCE_SCHEMAS =
        %w{answer contact guide detailed_guide document_collection publication}.freeze

      def initialize(content_item)
        @content_item = content_item
      end

      def show_taxonomy_navigation?
        !content_is_tagged_to_browse_pages? &&
          content_is_tagged_to_a_live_taxon? &&
          content_schema_is_guidance?
      end

      def show_step_by_step_breadcrumbs?
        step_navs.count == 1
      end

      def show_step_by_step_sidebar?
        step_navs.any? && step_navs.count < 5
      end

      def show_step_by_step_item?
        show_step_by_step_breadcrumbs? &&
          step_navs.first.dig("details", "step_by_step_nav", "steps").present?
      end

    private

      attr_reader :content_item

      def step_navs
        content_item.dig("links", "part_of_step_navs").to_a
      end

      def content_is_tagged_to_a_live_taxon?
        @content_item.dig("links", "taxons").to_a.any? { |taxon| taxon["phase"] == "live" }
      end

      def content_is_tagged_to_browse_pages?
        @content_item.dig("links", "mainstream_browse_pages").present?
      end

      def content_schema_is_guidance?
        GUIDANCE_SCHEMAS.include? @content_item["schema_name"]
      end
    end
  end
end
