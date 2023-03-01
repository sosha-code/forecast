require 'rails_helper'

RSpec.describe Forecast do
  let(:url) { 'https://api.openweathermap.org' }
  let(:zip) { '10001' }
  let(:cache) { Rails.cache }
  let(:cache_key) { "forecast-#{zip}" }
  let(:api_key) { Faker::Internet.password }
  let(:client) { Wrapper::OpenWeather::Client.new(api_key:, url:) }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  describe '#client' do
    it do
      expect(Forecast.client).to be_a(Wrapper::OpenWeather::Client)
    end
  end

  describe '#forecast_details' do
    before do
      allow(Forecast).to receive(:client).and_return(client)
    end

    context 'when cache is not present' do
      context 'when success' do
        before do
          allow(Forecast.client).to receive(:get_coordinates)
            .with(zip)
            .and_return({ data: { lat: '-96.764814', lon: '33.204274' }, status: 200 })
          allow(Forecast.client).to receive(:get_forecast_data)
            .with('-96.764814', '33.204274')
            .and_return({ data: { temp: '76',
                                  temp_min: '74',
                                  temp_max: '78',
                                  humidity: '40',
                                  description: 'clear' }, status: 200 })
        end

        it do
          expect(Forecast.forecast_details(zip)).to eq({ temp: '76', temp_min: '74', temp_max: '78', humidity: '40',
                                                         description: 'clear' })
        end
      end

      context 'when failure' do
        before do
          allow(Forecast.client).to receive(:get_coordinates)
            .with(zip)
            .and_return({ error: 'no data', status: 400 })
        end

        it do
          expect(Forecast.forecast_details(zip)).to eq({ error: 'no data', status: 400 })
        end
      end
    end

    context 'when cache is present' do
      let(:cached_response) do
        { temp: '76',
          temp_min: '74',
          temp_max: '78',
          humidity: '40',
          description: 'clear',
          cached: true }
      end

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it do
        Rails.cache.write(cache_key, cached_response)
        expect(Forecast.forecast_details(zip)).to eq(cached_response)
      end
    end
  end
end
