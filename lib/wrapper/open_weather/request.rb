module Wrapper
  module OpenWeather
    # open weather request obj
    class Request
      def initialize(client, method, path)
        @client = client
        @method = method
        @path = path
      end

      def perform
        connection.public_send(@method, @path)
      end

      private

      def connection
        Faraday.new(url: @client.url, ssl: { verify: true }) do |conn|
          conn.request :json
          conn.headers[:content_type] = 'application/json'
        end
      end
    end
  end
end
