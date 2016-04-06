module Grub
  class Gemfile

    GEM_LINE_REGEX = /\A\s*gem[\s(]+["']([^'"]*)["']/.freeze

    attr_accessor :gemfile_path, :gem_lines, :source

    def initialize(gemfile_path = Bundler.default_gemfile)
      @gemfile_path = gemfile_path
      @source = []
      @gem_lines = []
    end

    def parse
      self.source = File.readlines(gemfile_path)
      source.each_with_index do |line, i|
        if (match = GEM_LINE_REGEX.match(line))
          prev_line_comment = source[i - 1].strip.start_with?("#") ? source[i - 1] : nil
          self.gem_lines << GemLine.new(
            name: match[1],
            original_line: line,
            location: i,
            prev_line_comment: prev_line_comment
          )
        end
      end
    end

    def write_comments
      gem_lines.reverse.each do |gem_line|
        source.insert(gem_line.location , gem_line.comment) if gem_line.should_insert?
      end
      File.write(gemfile_path, source.join)
    end
  end
end
