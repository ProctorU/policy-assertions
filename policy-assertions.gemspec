# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'policy_assertions/version'

Gem::Specification.new do |spec|
  spec.name          = "policy-assertions"
  spec.version       = PolicyAssertions::VERSION
  spec.authors       = ['ProctorU']
  spec.email         = ['engineering@proctoru.com']
  spec.summary       = %q{Minitest assertions for Pundit policies.}
  spec.description   = %q{Minitest assertions for Pundit policies.}
  spec.homepage      = 'https://github.com/ksimmons/policy-assertions'
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.6'
  spec.add_development_dependency 'actionpack', '>= 3.0.0'
  spec.add_development_dependency 'rack', '~> 1.6.1'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'

  spec.add_dependency 'pundit', '>= 1.0.0'
  spec.add_dependency 'activesupport', '>= 3.0.0'
end
