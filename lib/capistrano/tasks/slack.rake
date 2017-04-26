require 'capistrano/slack/notifier'

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
    roles = ENV.fetch('ROLES', 'all')
    migrations = false

    updater.ping("#{deploy_username}: #{app_name.downcase}:#{branch_name} :point_right: #{stage}(#{roles})#{' + migrations' if migrations}")
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
      username: fetch(:slack_username, 'deploybot'),
      icon_emoji: fetch(:slack_avatar, ':squirrel:')
    )
  end
end

namespace :deploy do
  before :starting, 'slack:on_start'
  after :finished, 'slack:on_end'
  after :failed, 'slack:on_failure'
  after :rollback, 'slack:on_rollback'
end

