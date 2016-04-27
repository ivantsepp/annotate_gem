module Grub
  class GemLine

    attr_accessor :name, :original_line, :location, :prev_line_comment, :spec, :options

    def initialize(name:, original_line: nil, location: nil, prev_line_comment: nil, options: {})
      @name = name
      @original_line = original_line
      @location = location
      @prev_line_comment = prev_line_comment
      @options = options
    end

    def comment
      leading_spaces = original_line[0..leading_spaces_count - 1] if leading_spaces_count > 0
      comment = "#{leading_spaces}# #{info}"
    end

    def info
      output = if options[:website_only]
        website
      elsif options[:description_only]
        description
      else
        description_and_website
      end
      output << "\n"
    end

    def should_insert?
      !info.strip.empty? && !already_added_comment && !existing_comment_option
    end

    private

    def already_added_comment
      prev_line_comment && prev_line_comment.include?(comment)
    end

    # if there exists a prev_line_comment and the user has specified new_comments_only
    def existing_comment_option
      prev_line_comment && options[:new_comments_only]
    end

    def leading_spaces_count
      original_line.length - original_line.lstrip.length
    end

    def description
      "#{spec.summary}" if spec
    end

    def website
      "#{spec.homepage.to_s}" if spec
    end

    def description_and_website
      output = "#{description}"
      output << " (#{website})" unless website.nil? || website.empty?
      output
    end

  end
end
