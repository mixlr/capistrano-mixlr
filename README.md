# Capistrano::Slack

Notify slack on deploy start/end/rollback

## Installation

Add this line to your application's Gemfile:

```
gem 'capistrano-slack', github: 'mixlr/capistrano-slack'
```

or

```
gem 'capistrano-slack', git: 'https://github.com/mixlr/capistrano-slack'
```

And then execute:

```
$ bundle
```

## Usage

```
# Capfile
require 'capistrano/slack'

```

Configurable options (to set in `config/deploy.rb`)

```
slack_webhook_url: nil # REQUIRED, the slack webhook url to a channel to post to on deploy
```