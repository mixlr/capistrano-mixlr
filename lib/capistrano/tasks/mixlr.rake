require 'slack_updater'

namespace :defaults do
  task :defaults do
    set :slack_webhook_url -> { fetch(:slack_webhook_url) }
  end
end

namespace :deploy do
  after :started,   'mixlr:notify_slack_on_start'
  after :published, 'mixlr:notify_slack_on_end'
  after :rollback,  'mixlr:notify_slack_on_rollback'
end

namespace :mixlr do
  desc 'Notify slack of deploy started'
  task :notify_slack_on_start do
    deploy_username = `git config --get user.name`.chomp
    if deploy_username.length == 0
      abort 'set git user.name config variable before deploying'
    end

    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    stage = fetch(:stage)
    roles = ENV['ROLES']
    migrations = false

    updater.ping("#{deploy_username}: #{branch_name} :point_right: #{stage}(#{roles})#{' + migrations' if migrations}")
  end

  desc 'Notify slack of deploy ended'
  task :notify_slack_on_end do
    stage = fetch(:stage)
    updater.ping(":thumbsup: #{stage}.")
  end

  desc 'Notify slack of deploy rolled back'
  task :notify_slack_on_rollback do
    stage = fetch(:stage)
    updater.ping(":thumbsdown: #{stage} was rolled back.")
  end

  def updater
    @updater ||= SlackUpdater.new(
      fetch(:slack_webhook_url),
      username: 'deploybot',
      icon_emoji: ':squirrel:'
    )
  end
end