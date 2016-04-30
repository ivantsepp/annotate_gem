module AnnotateGem
  module SpecFinder
    extend self

    def find_specs_for(gem_lines, &block)
      gem_lines = Array(gem_lines)
      find_matching_specs_for(gem_lines)
      gems_to_fetch = gem_lines.select { |gem_line| gem_line.spec.nil? }
      fetch_specs_for(gems_to_fetch, &block) if gems_to_fetch.any?
    end

    def find_matching_specs_for(gem_lines)
      gem_lines.each do |line|
        matching_specs = Gem::Dependency.new(line.name).matching_specs
        # TODO: need to find latest
        line.spec = matching_specs.first if matching_specs.any?
      end
    end

    def fetch_specs_for(gem_lines)
      total = gem_lines.length
      processing = 0
      yield processing, total if block_given?
      # TODO: Support private sources
      remote = Bundler::Source::Rubygems::Remote.new(Gem.sources.first.uri)
      fetcher = Bundler::Fetcher.new(remote)
      dependency_fetcher = fetcher.fetchers.find {|f| Bundler::Fetcher::Dependency === f }
      versions, _ = dependency_fetcher.dependency_specs(gem_lines.collect(&:name))
      gem_lines.each do |gem_line|
        processing += 1
        yield processing, total if block_given?
        gem_versions = versions.select { |v| v.first == gem_line.name }
        next if gem_versions.empty? # couldn't find version on RubyGems so go to next one
        version = find_latest_version(gem_versions)
        gem_line.spec = fetcher.fetch_spec([gem_line.name, version])
      end
    end

    def find_latest_version(versions)
       versions.sort_by { |v| v[1] }.last[1]
    end
  end
end
