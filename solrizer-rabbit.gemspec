# -*- encoding: utf-8 -*-
require File.expand_path('../lib/solrizer-rabbit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["TODO: Write your name"]
  gem.email         = ["justin.coyne@yourmediashelf.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "solrizer-rabbit"
  gem.require_paths = ["lib"]
  gem.version       = Solrizer::Rabbit::VERSION
end
