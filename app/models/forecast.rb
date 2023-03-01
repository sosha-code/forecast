class Forecast
  def self.client
    Wrapper::OpenWeather::Client.new(api_key: Rails.application.credentials.openweather_app_key)
  end

  def self.forecast_details(zip)
    Rails.cache.read(cache_key(zip)) || get_forecast_details(zip)
  end

  def self.get_forecast_details(zip)
    coordinates = coordinates_data(zip)

    return coordinates unless coordinates[:data].present?

    forecast_data(coordinates[:data][:lat], coordinates[:data][:lon], zip)
  end

  def self.coordinates_data(zip)
    client.get_coordinates(zip)
  end

  def self.forecast_data(lat, lon, zip)
    forecast_data = client.get_forecast_data(lat, lon)
    return forecast_data unless forecast_data[:data].present?

    Rails.cache.write(cache_key(zip), forecast_data[:data].merge(cached: true),
                      expires_in: 30.minutes)

    forecast_data[:data]
  end

  def self.cache_key(zip)
    "forecast-#{zip}"
  end

  private_class_method :get_forecast_details, :coordinates_data, :forecast_data, :cache_key
end
