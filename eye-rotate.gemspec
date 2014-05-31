# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eye-rotate/version'

Gem::Specification.new do |spec|
  spec.name          = "eye-rotate"
  spec.version       = Eye::Rotate::VERSION
  spec.authors       = ["'Konstantin Makarchev'"]
  spec.email         = ["'kostya27@gmail.com'"]
  spec.summary       = %q{ Rotate logs for eye gem }
  spec.description   = %q{ Rotate logs for eye gem }
  spec.homepage      = "https://github.com/kostya/eye-rotate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "eye", '>= 0.6'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
