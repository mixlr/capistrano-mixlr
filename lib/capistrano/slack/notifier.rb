require 'slack-notifier'

module Capistrano
  module Slack
    class Notifier
      def initialize(webhook_url, options = {})
        @webhook_url = webhook_url
        @options     = options
      end

      def ping(message)
        begin
          slack.ping(message, options)
        rescue ::Slack::Notifier::APIError
        end
      end

      private
      attr_reader :webhook_url, :options

      def slack
        @slack ||= ::Slack::Notifier.new(webhook_url)
      end
    end
  end
end
