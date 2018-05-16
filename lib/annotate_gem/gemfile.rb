module AnnotateGem
  class Gemfile

    GEM_LINE_REGEX = /\A\s*gem[\s(]+["'](?<name>[^'"]*)["']/.freeze

    attr_accessor :gemfile_path, :gem_lines, :source, :options

    def initialize(gemfile_path, options = {})
      @gemfile_path = gemfile_path
      @source = []
      @gem_lines = []
      @options = options
    end

    def parse
      self.source = File.readlines(gemfile_path, :encoding => 'UTF-8')
      source.each_with_index do |line, i|
        match = GEM_LINE_REGEX.match(line)
        if match
          prev_line = source[i - 1] if i > 0
          prev_line_comment = prev_line if is_line_a_comment?(prev_line)
          self.gem_lines << GemLine.new(
            name: match[:name],
            original_line: line,
            location: i,
            prev_line_comment: prev_line_comment,
            options: options
          )
        end
      end
    end

    def write_comments
      gem_lines.reverse.each do |gem_line|
        next unless gem_line.should_insert?
        if options[:inline]
          source[gem_line.location] = gem_line.inline_comment
        else
          source.insert(gem_line.location, gem_line.comment)
        end
      end
      File.write(gemfile_path, source.join)
    end

    private

    def is_line_a_comment?(line)
      line && line.strip.start_with?("#")
    end

  end
end
