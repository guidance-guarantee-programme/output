class OutputDocument
  class HTMLRenderer < SimpleDelegator
    attr_accessor :output_document

    def initialize(output_document)
      @output_document = output_document
      __setobj__(output_document)
    end

    def pages_to_render
      case output_document.variant
      when 'tailored'
        circumstances = %i(continue_working unsure leave_inheritance
                           wants_flexibility wants_security wants_lump_sum
                           poor_health).select do |c|
          output_document.public_send(c)
        end

        [:cover_letter, :introduction, circumstances, :other_information].flatten
      when 'generic'
        %w(cover_letter introduction generic_guidance other_information)
      when 'other'
        %w(ineligible)
      end
    end

    def stylesheet(filename)
      css = Sass.compile(ERB.new(
        File.read(Rails.root.join('app', 'assets', 'stylesheets', filename))
      ).result(binding))
      "<style>\n#{css}\n</style>".html_safe
    end

    def render
      ERB.new(template).result(binding)
    end

    private

    def template
      [:header, pages_to_render, :footer].flatten.reduce('') do |result, section|
        result << template_for(section) << "\n\n"
      end
    end

    def template_for(section)
      File.read(
        Rails.root.join('app', 'templates', "output_document_#{section}.html.erb"))
    end
  end
end
