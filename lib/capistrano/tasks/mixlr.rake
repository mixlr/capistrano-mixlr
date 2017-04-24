require 'slack_notifier'

namespace :defaults do
  task :defaults do
    set :slack_webhook_url, -> { fetch(:slack_webhook_url) }
  end
end

namespace :deploy do
  after :started, 'notify_slack_on_start' do
    invoke 'mixlr:notify_slack_on_start'
  end

  after :published, 'notify_slack_on_end' do
    invoke 'mixlr:notify_slack_on_end'
  end

  after :failed, 'notify_slack_on_failure' do
    invoke 'mixlr:notify_slack_on_failure'
  end

  after :rollback, 'notify_slack_on_rollback' do
    invoke 'mixlr:notify_slack_on_rollback'
  end
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
    roles = ENV['ROLES'] || 'all'
    migrations = false

    updater.ping("#{deploy_username}: #{branch_name} :point_right: #{stage}(#{roles})#{' + migrations' if migrations}")
  end

  desc 'Notify slack of deploy ended'
  task :notify_slack_on_end do
    stage = fetch(:stage)
    updater.ping(":thumbsup: #{stage}.")
  end

  desc 'Notify slack of deploy failed'
  task :notify_slack_on_failure do
    stage = fetch(:stage)
    updater.ping(":thumbsdown: #{stage}.")
  end

  desc 'Notify slack of deploy rolled back'
  task :notify_slack_on_rollback do
    stage = fetch(:stage)
    updater.ping(":thumbsdown: #{stage} was rolled back.")
  end

  def updater
    @updater ||= SlackNotifier.new(
      fetch(:slack_webhook_url),
      username: 'deploybot',
      icon_emoji: ':squirrel:'
    )
  end
end

