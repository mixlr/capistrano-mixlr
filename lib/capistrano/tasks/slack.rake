require 'capistrano/slack/notifier'

namespace :defaults do
  task :defaults do
    set :slack_webhook_url, -> { fetch(:slack_webhook_url) }
  end
end

namespace :deploy do
  after :started, 'on_start' do
    invoke 'slack:on_start'
  end

  after :published, 'on_end' do
    invoke 'slack:on_end'
  end

  after :failed, 'on_failure' do
    invoke 'slack:on_failure'
  end

  after :rollback, 'on_rollback' do
    invoke 'slack:on_rollback'
  end
end

namespace :slack do
  desc 'Notify slack of deploy started'
  task :on_start do
    deploy_username = `git config --get user.name`.chomp
    if deploy_username.length == 0
      abort 'set git user.name config variable before deploying'
    end

    app_name = fetch(:application)
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    stage = fetch(:stage)
    roles = ENV['ROLES'] || 'all'
    migrations = false

    updater.ping("#{deploy_username}: #{app_name}:#{branch_name} :point_right: #{stage}(#{roles})#{' + migrations' if migrations}")
  end

  desc 'Notify slack of deploy ended'
  task :on_end do
    stage = fetch(:stage)
    updater.ping(":thumbsup: #{stage}.")
  end

  desc 'Notify slack of deploy failed'
  task :on_failure do
    stage = fetch(:stage)
    updater.ping(":thumbsdown: #{stage}.")
  end

  desc 'Notify slack of deploy rolled back'
  task :on_rollback do
    stage = fetch(:stage)
    updater.ping(":thumbsdown: #{stage} was rolled back.")
  end

  def updater
    @updater ||= Capistrano::Slack::Notifier.new(
      fetch(:slack_webhook_url),
      username: 'deploybot',
      icon_emoji: ':squirrel:'
    )
  end
end

