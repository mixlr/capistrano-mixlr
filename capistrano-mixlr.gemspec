lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/slack/version'

Gem::Specification.new do |spec|
  spec.name        = 'capistrano-slack'
  spec.version     = Capistrano::Slack::VERSION
  spec.authors     = ['Thibault Gautriaud']
  spec.email       = ['thibault@mixlr.com']
  spec.summary     = %q{Slack integration for Capistrano}
  spec.description = %q{Slack integration for Capistrano}
  spec.homepage    = 'https://github.com/mixlr/capistrano-slack'

  spec.required_ruby_version  = '>= 2.2'
  spec.files = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '>= 3.4'
  spec.add_dependency 'slack-notifier', '>= 2.1'
end