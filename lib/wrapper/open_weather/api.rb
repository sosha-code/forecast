# OpenWeather Service Endpoints
module Wrapper
  module OpenWeather
    # api methods
    module Api
      def get_coordinates(zip)
        response = perform_request(:get,
                                   "/geo/1.0/zip?appid=#{api_key}&zip=#{zip}")
        response_body = JSON.parse(response.body)
        return { data: coordinates_data(response_body), status: response.status } if response.status == 200

        { error: response_body['message'], status: response.status }
      end

      def get_forecast_data(lat, lon)
        response = perform_request(:get,
                                   "/data/2.5/weather?appid=#{api_key}&lat=#{lat}&lon=#{lon}&units=imperial")

        response_body = JSON.parse(response.body)
        return { data: forecast_data(response_body), status: response.status } if response.status == 200

        { error: response_body['message'], status: response.status }
      end

      # private

      def perform_request(method, path)
        Request.new(self, method, path).perform
      end

      def coordinates_data(response_body)
        { lat: response_body['lat'], lon: response_body['lon'] }
      end

      def forecast_data(response_body)
        details = response_body['main']
        { temp: details['temp'],
          temp_min: details['temp_min'],
          temp_max: details['temp_max'],
          humidity: details['humidity'],
          description: response_body['weather'][0]['description'] }
      end
    end
  end
end
