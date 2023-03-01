require 'rails_helper'

RSpec.describe ForecastsController do
  describe '#show' do
    let(:url) { 'https://api.openweathermap.org' }
    let(:api_key) { 'wPUIOtGvnIyaYGp' }
    let(:zip) { '10001' }
    let(:get_coordinates_endpoint) { "#{url}/geo/1.0/zip?appid=#{api_key}&zip=#{zip}" }
    let(:headers) do
      {
        'Content-Type': 'application/json'
      }
    end
    let(:response_data) do
      { temp: '76',
        temp_min: '74',
        temp_max: '78',
        humidity: '40',
        description: 'clear' }
    end

    context 'when success' do
      before do
        allow(Forecast).to receive(:forecast_details).with(zip).and_return(response_data)
      end

      it do
        get(
          :index,
          params: {
            zip:
          }
        )

        expect(response).to be_successful
      end
    end

    context 'when error' do
      before do
        allow(Forecast).to receive(:forecast_details).with(zip).and_return({ error: 'no data', status: 400 })
      end

      it do
        get(
          :index,
          params: {
            zip:
          }
        )
        expect(flash[:error]).to eq('no data')
      end
    end

    context 'when zip is missing' do
      let(:zip) { '' }
      it do
        get(
          :index,
          params: {
            zip:
          }
        )
        expect(flash[:error]).to eq('Enter valid Zip.')
      end
    end
  end
end
