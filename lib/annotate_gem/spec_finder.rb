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
      fetcher = bundler_fetcher
      versions = get_versions(fetcher, gem_lines.collect(&:name))
      gem_lines.each do |gem_line|
        processing += 1
        yield processing, total if block_given?
        gem_versions = versions.select { |v| v.first == gem_line.name }
        next if gem_versions.empty? # couldn't find version on RubyGems so go to next one
        version = find_latest_version(gem_versions)
        platform = find_latest_version_platform(gem_versions)
        gem_line.spec = fetcher.fetch_spec([gem_line.name, version, platform])
      end
    end

    def find_latest_version(versions)
      versions.sort_by { |v| v[1] }.last[1]
    end

    def find_latest_version_platform(versions)
      versions.sort_by { |v| v[1] }.last[2]
    end

    private

    # TODO: Support private sources
    def bundler_fetcher
      # Bundler versions 1.10.0 moves AnonymizableURI to Source::Rubygems::Remote
      # See https://github.com/bundler/bundler/pull/3476
      if defined?(Bundler::Source::Rubygems::Remote)
        remote = Bundler::Source::Rubygems::Remote.new(Gem.sources.first.uri)
      else
        remote = Gem.sources.first.uri
      end
      Bundler::Fetcher.new(remote)
    end

    def get_versions(fetcher, names)
      # Bundler versions 1.10.0 moves fetchers into separate classes
      # See https://github.com/bundler/bundler/pull/3518
      if fetcher.respond_to?(:fetch_dependency_remote_specs, true)
        versions, _ = fetcher.send(:fetch_dependency_remote_specs, names)
      else
        # require 'pry'; binding.pry
        dependency_fetcher = fetcher.fetchers.find {|f| Bundler::Fetcher::Dependency === f }
        versions, _ = dependency_fetcher.dependency_specs(names)
      end
      versions
    end

  end
end
