module Grub
  class GemLine

    attr_accessor :name, :original_line, :location, :prev_line_comment, :spec

    def initialize(name:, original_line:, location:, prev_line_comment: nil)
      @name = name
      @original_line = original_line
      @location = location
      @prev_line_comment = prev_line_comment
    end

    def comment
      leading_spaces = original_line[0..leading_spaces_count - 1] if leading_spaces_count > 0
      comment = "#{leading_spaces}# #{description}"
      comment << " (#{website})" unless website.nil? || website.empty?
      comment << "\n"
      comment
    end

    def should_insert?
      prev_line_comment.nil? || !prev_line_comment.include?(comment)
    end

    private

    def leading_spaces_count
      original_line.length - original_line.lstrip.length
    end

    def description
      spec.summary if spec
    end

    def website
      spec.homepage if spec
    end

  end
end
