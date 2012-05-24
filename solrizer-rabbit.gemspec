# -*- encoding: utf-8 -*-
require File.expand_path('../lib/solrizer-rabbit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Coyne"]
  gem.email         = ["justin.coyne@yourmediashelf.com"]
  gem.description   = %q{Solrize fedora objects using a queue}
  gem.summary       = %q{Solrize fedora objects using a queue}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "solrizer-rabbit"
  gem.require_paths = ["lib"]
  gem.version       = Solrizer::Rabbit::VERSION

  gem.add_dependency('solrizer-fedora', '~> 2.1') 
  gem.add_dependency('carrot') 

  gem.add_development_dependency('rspec')

end
