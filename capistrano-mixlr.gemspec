lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/mixlr/version'

Gem::Specification.new do |spec|
  spec.name        = 'capistrano-mixlr'
  spec.version     = Capistrano::Mixlr::VERSION
  spec.authors     = ['Thibault Gautriaud']
  spec.email       = ['thibault@mixlr.com']
  spec.summary     = %q{Mixlr integration for Capistrano}
  spec.description = %q{Mixlr integration for Capistrano}
  spec.homepage    = 'https://github.com/mixlr/capistrano-mixlr'

  spec.required_ruby_version  = '>= 2.2'
  spec.files = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano'
  spec.add_dependency 'slack-notifier', '>= 2.1'
end