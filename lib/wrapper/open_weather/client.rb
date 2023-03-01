module Wrapper
  module OpenWeather
    # open weather client
    class Client
      include Api

      URL = 'https://api.openweathermap.org'.freeze
      attr_reader :api_key, :url

      def initialize(credentials)
        @url = URL
        @api_key = credentials.fetch(:api_key)
      end
    end
  end
end
