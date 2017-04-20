# Capistrano::Mixlr

Notify slack on deploy/rollback

## Installation

Add this line to your application's Gemfile:

```
gem 'capistrano-mixlr', github: 'mixlr/capistrano-mixlr'
```

And then execute:

```
$ bundle
```

## Usage

```
# Capfile
require 'capistrano/mixlr'

```

Configurable options (to set in `config/deploy.rb`)

```
slack_webhook_url: nil # REQUIRED, the slack webhook url to a channel to post to on deploy
```