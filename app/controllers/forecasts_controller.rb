class ForecastsController < ApplicationController
  def index
    if params[:zip].present?
      @forecast_data = Forecast.forecast_details(params[:zip])
      flash.now[:error] = @forecast_data[:error] if @forecast_data[:error].present?
    else
      flash.now[:error] = 'Enter valid Zip.'
    end
  end
end
