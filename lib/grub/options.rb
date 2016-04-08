require "optparse"

module Grub
  class Options

    attr_accessor :options, :options_parser

    def initialize
      @options = {}
      @options_parser = OptionParser.new do |opts|
        add_banner(opts)
        add_tail_options(opts)
      end
    end

    def parse!(args)
      options_parser.parse!(args)
      options
    end

    private

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
