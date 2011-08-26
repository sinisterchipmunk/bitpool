# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bitpool/version"

Gem::Specification.new do |s|
  s.name        = "bitpool"
  s.version     = Bitpool::VERSION
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "bitpool"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec',      '~> 2.6.0'
  s.add_development_dependency 'fakeweb',    '~> 1.3.0'
  s.add_development_dependency 'rake',       '~> 0.9.2'
  s.add_development_dependency 'bundler',    '~> 1.0.18'
  
  s.add_runtime_dependency 'redis-orm',      '~> 0.0.3'
  s.add_runtime_dependency 'bitcoin-client', '~> 0.0.1'
  s.add_runtime_dependency 'rack',           '~> 1.3.2'
end
