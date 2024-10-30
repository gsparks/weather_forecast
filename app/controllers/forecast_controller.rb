class ForecastController < ApplicationController

  include ForecastHelper

  def index
    @forecast = get_forecast(params[:address])
    render "forecast/index"
  end
end
