# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "./lib/fuzzy-logic.rb"

Gem::Specification.new do |gem|
  gem.name          = "fuzzy-logic"
  gem.version       = FuzzyLogic::VERSION
  gem.authors       = ["Adrian E."]
  gem.email         = ["ae@writedown.eu"]
  gem.description   = %q{fuzzy-logic and fuzzy-rules are really handy for some problems.}
  gem.summary       = %q{brings fuzzy-logic and fuzzy-rules to ruby}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('guard-minitest')
  gem.add_development_dependency('rb-inotify', '~> 0.8.8')
end
