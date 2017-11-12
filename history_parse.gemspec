# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'history_parse/version'

Gem::Specification.new do |spec|
  spec.name          = "history_parse"
  spec.version       = HistoryParse::VERSION
  spec.authors       = ["Colin Mitchell"]
  spec.email         = ["muffinista@gmail.com"]
  spec.summary       = %q{Scrape history data from wikipedia}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "mediawiki-gateway"
  spec.add_dependency "json"
  spec.add_dependency "nokogiri"  
end
