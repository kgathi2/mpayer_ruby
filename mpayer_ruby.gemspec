# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mpayer_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "mpayer_ruby"
  spec.version       = Mpayer::VERSION
  spec.authors       = ["Kariuki Gathitu"]
  spec.email         = ["kgathi2@gmail.com"]

  spec.summary       = %q{Ruby client for interfacing with http://app.mpayer.co.ke/api }
  spec.description   = %q{Interfaces with Mpayer payment gateway api  }
  spec.homepage      = "https://github.com/kgathi2/mpayer_ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "minitest", "~> 5.6"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-nav", "~> 0.2"
  spec.add_development_dependency "pry-alias", "~> 0.0"
  spec.add_development_dependency "coveralls", '~> 0'
  spec.add_development_dependency "webmock", '~> 1.21'
  spec.add_development_dependency "sinatra", '~> 1.4'
  spec.add_development_dependency "faker", '~> 1.4'

  spec.add_dependency 'activesupport', "~> 4.2"
  spec.add_dependency 'httparty', "~> 0.13"
  spec.add_dependency 'wsse', "~> 0.0"
  spec.add_dependency 'hashie', "~> 3.4"
end
