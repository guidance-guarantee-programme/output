# frozen_string_literal: true
require 'rspec/expectations'

module OutputDocumentSectionsMatchers
  module SectionMatchExpressions
    def section_match_expression(section)
      section = Regexp.escape(section)

      /<!-- section: #{section}(?:, version: (.*))? -->/
    end

    def section_capture_expression
      /<!-- section: (.*?)(?:, version: (.*?))? -->/
    end
  end

  RSpec::Matchers.define :include_output_document_section do |section|
    include SectionMatchExpressions

    chain :at_version, :version

    match do |page|
      expression = section_match_expression(section)
      matches = page.source.scan(expression)
      @failure = :no_sections if matches.empty?
      if version
        if matches.count > 1
          @failure = :too_many_versions
        elsif (@actual_version = matches[0][0]) != version
          @failure = :incorrect_version
        end
      end

      !@failure
    end

    failure_message do
      case @failure
      when :no_sections
        "expected page to include output document section \"#{section}\""
      when :too_many_versions
        "expected page to include output document section \"#{section}\" at " \
        "version \"#{version}\", but multiple versions were found"
      when :incorrect_version
        "expected page to include output document section \"#{section}\" at " \
        "version \"#{version}\", but version \"#{@actual_version}\" was found"
      end
    end
  end

  RSpec::Matchers.define :include_output_document_sections do |sections|
    include SectionMatchExpressions

    chain :at_version, :version

    match do |page|
      section_indexes = sections.map do |section|
        page.source =~ section_match_expression(section)
      end

      !section_indexes.any?(&:nil?) && section_indexes.sort == section_indexes
    end

    failure_message do
      actual_sections = page.source.scan(section_capture_expression).map(&:first)

      "expected page to include output document sections (in order):\n" \
      "  #{sections}\n\n" \
      "page contained:\n" \
      "  #{actual_sections}\n\n"
    end
  end
end

World(OutputDocumentSectionsMatchers)
