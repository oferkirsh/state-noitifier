# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'state/notifier/version'

Gem::Specification.new do |spec|
  spec.name          = "state-notifier"
  spec.version       = State::Notifier::VERSION
  spec.authors       = ["Vitaly Kushner"]
  spec.email         = ["vitaly@astrails.com"]
  spec.description   = %q{Simple gem to notify 'subscribers' about record state changes.}
  spec.summary       = %q{Simple gem to notify 'subscribers' about record state changes.}
  spec.homepage      = "https://github.com/vitaly/state-notifier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rails"
end
