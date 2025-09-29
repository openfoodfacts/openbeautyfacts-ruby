# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openbeautyfacts/version'

Gem::Specification.new do |spec|
  spec.name          = 'openbeautyfacts'
  spec.version       = Openbeautyfacts::VERSION
  spec.authors       = ['Nicolas Leger', 'Pierre Slamich']
  spec.email         = ['contact@openfoodfacts.org']

  spec.summary       = 'Open Beauty Facts API Wrapper'
  spec.description   = 'Open Beauty Facts API Wrapper, the open database about beauty products.'
  spec.homepage      = 'https://github.com/openfoodfacts/openbeautyfacts-ruby'
  spec.license       = 'MIT'

  spec.files         = Dir['Rakefile', '{features,lib}/**/*', 'README*', 'LICENSE*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5' # Needed for URI.open

  spec.add_runtime_dependency 'openfoodfacts', '~> 0.10.0'
  # Depencies of openfoodfacts
  spec.add_runtime_dependency 'hashie', '>= 3.4', '< 6.0'
  spec.add_runtime_dependency 'nokogiri', '~> 1.16'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'minitest', '~> 5.25'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.11'
end
