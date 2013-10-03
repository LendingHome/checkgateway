# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checkgateway/version'

Gem::Specification.new do |spec|
  spec.name          = "checkgateway"
  spec.version       = Checkgateway::VERSION
  spec.authors       = ["Keith Tom"]
  spec.email         = ["keith.tom@gmail.com"]
  spec.description   = "Implements the ACH and Consumer API via the CGI interface."
  spec.summary       = "Basic client for CheckGateway"
  spec.homepage      = "https://github.com/LendingHome/checkgateway"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "builder"
  spec.add_dependency "activesupport"
end
