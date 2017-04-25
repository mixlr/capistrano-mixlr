require 'slack-notifier'

module Capistrano
  module Slack
    class Notifier
      def initialize(webhook_url, options = {})
        @webhook_url = webhook_url
        @options     = options
      end

      def ping(message, options = {})
        options[:username] ||= 'deploybot'
        options[:icon_emoji] ||= ':robot_face:'

        slack.ping(message, options)
      end

      private
      attr_reader :webhook_url, :options

      def slack
        @slack ||= ::Slack::Notifier.new(webhook_url)
      end
    end
  end
end