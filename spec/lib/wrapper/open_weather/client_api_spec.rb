require 'rails_helper'

RSpec.describe Wrapper::OpenWeather::Client do
  let(:url) { 'https://api.openweathermap.org' }
  let(:api_key) { 'wPUIOtGvnIyaYGp' }
  let(:credentials) do
    { api_key:, url: }
  end
  let(:client) { described_class.new(credentials) }
  let(:ride) { create(:ride) }
  let(:zip) { '90210' }
  let(:lat) { '44.34' }
  let(:lon) { '10.99' }

  let(:headers) do
    {
      'Content-Type': 'application/json'
    }
  end

  describe '#get_coordinates' do
    let(:get_coordinates_endpoint) { "#{url}/geo/1.0/zip?appid=#{api_key}&zip=#{zip}" }

    context 'when success' do
      before do
        stub_request(:get, get_coordinates_endpoint)
          .to_return(
            status: 200,
            body: file_fixture('get_coordinates_success.json')
          )
      end

      it 'returns coordinates' do
        response = client.get_coordinates(zip)
        expect(a_request(:get, get_coordinates_endpoint)
        .with(
          headers:
        )).to have_been_made.once

        expect(response[:status]).to eq(200)
      end
    end

    context 'when failure' do
      before do
        stub_request(:get, get_coordinates_endpoint)
          .to_return(
            status: 400,
            body: { error: 'something went wrong' }.to_json
          )
      end

      it 'returns coordinates' do
        response = client.get_coordinates(zip)
        expect(a_request(:get, get_coordinates_endpoint)
        .with(
          headers:
        )).to have_been_made.once

        expect(response[:status]).to eq(400)
      end
    end
  end

  describe '#get_forecast_data' do
    let(:get_forecast_data_endpoint) do
      "#{url}/data/2.5/weather?appid=#{api_key}&lat=#{lat}&lon=#{lon}&units=imperial"
    end

    context 'when success' do
      before do
        stub_request(:get, get_forecast_data_endpoint)
          .to_return(
            status: 200,
            body: file_fixture('get_forecast_data_success.json')
          )
      end

      it 'returns distance' do
        response = client.get_forecast_data(lat, lon)
        expect(a_request(:get, get_forecast_data_endpoint)
        .with(
          headers:
        )).to have_been_made.once

        expect(response[:status]).to eq(200)
      end
    end

    context 'when failure' do
      before do
        stub_request(:get, get_forecast_data_endpoint)
          .to_return(
            status: 400,
            body: { error: 'something went wrong' }.to_json
          )
      end

      it 'returns distance' do
        response = client.get_forecast_data(lat, lon)
        expect(a_request(:get, get_forecast_data_endpoint)
        .with(
          headers:
        )).to have_been_made.once

        expect(response[:status]).to eq(400)
      end
    end
  end
end
