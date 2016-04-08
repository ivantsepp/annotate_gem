require "optparse"

module Grub
  class Options

    attr_accessor :options, :options_parser

    def initialize
      @options = {}
      @options_parser = OptionParser.new do |opts|
        add_banner(opts)
        add_tail_options(opts)
        add_info_options(opts)
        add_gemfile_comment_options(opts)
      end
    end

    def parse!(args)
      options_parser.parse!(args)
      validate_options
      options
    end

    private

    def validate_options
      info_flags = options[:website_only] && options[:description_only]
      raise ArgumentError, "Cannot set both --website-only and --description-only flags" if info_flags
    end

    def add_info_options(opts)
      opts.on("--website-only", "Only output the website") do
        options[:website_only] = true
      end
      opts.on("--description-only", "Only output the description") do
        options[:description_only] = true
      end
    end

    def add_gemfile_comment_options(opts)
      opts.on("--new-comments-only", "Only add a comment to gemfile if there isn't a comment already") do
        options[:new_comments_only] = true
      end
    end

    def add_banner(opts)
      opts.banner = <<-BANNER.gsub(/\A\s{8}/, '')
        #{Grub::DESCRIPTION}
        Usage: #{opts.program_name} [options]
               #{opts.program_name} [gem name]
      BANNER
    end

    def add_tail_options(opts)
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
      opts.on_tail("-v", "--version", "Show version") do
        puts Grub::VERSION
        exit
      end
    end

  end
end
