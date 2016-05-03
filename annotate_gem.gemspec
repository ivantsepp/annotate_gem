# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annotate_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "annotate_gem"
  spec.version       = AnnotateGem::VERSION
  spec.authors       = ["Ivan Tse"]
  spec.email         = ["ivan.tse1@gmail.com"]
  spec.summary       = AnnotateGem::DESCRIPTION
  spec.description   = <<-DESCRIPTION.gsub(/^\s+/, "").gsub(/\n/, " ")
                        Clarify your dependencies by adding a detailed comment to each line in Gemfile specifying the
                        gem's summary and its website if any.
                       DESCRIPTION
  spec.homepage      = "https://github.com/ivantsepp/annotate_gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler", "~> 1.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.1"
end
