require 'slack-notifier'

class SlackUpdater
  WEBHOOK_URLS = {
    testing: 'https://hooks.slack.com/services/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',
    deploy: 'https://hooks.slack.com/services/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'
  }

  def initialize(channel_name)
    @channel_name = channel_name

    webhook_url = WEBHOOK_URLS[channel_name.to_sym]
    if webhook_url
      @client = Slack::Notifier.new(webhook_url)
    else
      puts "Warning: no webhook URL found for channel name '%s'. (Available: %s)" % [ channel_name, WEBHOOK_URLS.keys.inspect ]
    end
  end

  def ping(message, options={})
    options[:username] ||= 'opsbot'
    options[:icon_emoji] ||= ':robot_face:'
    @client.ping(message, options)
  end
end
