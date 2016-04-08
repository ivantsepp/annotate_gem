module Grub
  module SpecFinder
    extend self

    def find_specs_for(gem_lines)
      find_matching_specs_for(gem_lines)
      gems_to_fetch = gem_lines.select { |gem_line| gem_line.spec.nil? }
      fetch_specs_for(gems_to_fetch) if gems_to_fetch.any?
    end

    def find_matching_specs_for(gem_lines)
      Bundler.configure
      gem_lines.each do |line|
        matching_specs = Gem::Dependency.new(line.name).matching_specs
        line.spec = matching_specs.first if matching_specs.any?
      end
    end

    def fetch_specs_for(gem_lines)
      print "Fetching gem metadata..."
      fetcher = Bundler::Fetcher.new(Gem.sources.first.uri)
      versions, _ = fetcher.send(:fetch_dependency_remote_specs, gem_lines.collect(&:name))
      gem_lines.each do |gem_line|
        print "."
        version = versions.find{ |v| v.first == gem_line.name }[1]
        spec = fetcher.fetch_spec([gem_line.name, version])
        gem_line.spec = spec
      end
      print "\n"
    end

  end
end
