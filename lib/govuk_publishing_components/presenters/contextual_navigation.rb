require 'govuk_navigation_helpers'

module GovukPublishingComponents
  module Presenters
    # @private
    class ContextualNavigation
      delegate :should_present_taxonomy_navigation?,
        :should_present_step_by_step_breadcrumbs?,
        :show_step_by_step_sidebar?,
        :show_step_by_step_item?,
        to: :what_to_show

      # @param content_item A content item hash with strings as keys
      # @param request_path `request.path`
      def initialize(content_item, request_path)
        @content_item = content_item
        @request_path = request_path
      end

      def taxonomy_sidebar
        @taxonomy_sidebar ||= GovukNavigationHelpers::TaxonomySidebar.new(content_item).sidebar
      end

      def taxon_breadcrumbs
        @taxon_breadcrumbs ||= GovukNavigationHelpers::TaxonBreadcrumbs.new(content_item).breadcrumbs
      end

      def breadcrumbs_based_on_parent
        if content_item["schema_name"] == "specialist_document"
          SpecialistDocumentBreadcrumbs.new(content_item).breadcrumbs
        else
          BreadcrumbsBasedOnParent.new(content_item).breadcrumbs
        end
      end

      def step_nav_helper
        @step_nav_helper ||= StepNavHelper.new(content_item, request_path)
      end

    private

      attr_reader :content_item, :request_path

      def what_to_show
        @what_to_show ||= WhatToShow.new(content_item)
      end
    end
  end
end
