require 'slack-notifier'

class SlackNotifier
  def initialize(webhook_url)
    @webhook_url = webhook_url
  end

  def ping(message, options={})
    options[:username] ||= 'opsbot'
    options[:icon_emoji] ||= ':robot_face:'

    slack.ping(message, options)
  end

  private
  attr_reader :webhook_url

  def slack
    @slack ||= Slack::Notifier.new(webhook_url)
  end
end
