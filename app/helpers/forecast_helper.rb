module ForecastHelper
  require 'net/http'

  def get_forecast(address)
    if (address == placeholder_text) || (address == nil)
      ''
    else
      zip = zip_code(address)
      forecast = request_forecast(zip)
      format_forecast(forecast)
    end
  end

  private

  def placeholder_text
    'Enter address here...'
  end

  def zip_code_error_text
    'Please use an address with a valid zip code.'
  end

  def api_error_text(forecast)
    "An error occurred: #{forecast['error']['message']}"
  end

  def weather_api_key
    Rails.application.credentials.weather_api_key
  end

  # Retuns a formatted forecast string.
  def format_forecast(forecast)
    return forecast if forecast == zip_code_error_text
    return api_error_text(forecast) if forecast['error']

    current_data = forecast['current']  
    location_data = forecast['location']
    forecast_base_string = "Temperature in #{location_data['name']}, #{location_data['region']} is currently #{current_data['temp_f']}F / #{current_data['temp_c']}C"
    if forecast['cached']
      (forecast_base_string + ' (cached)')
    else
      forecast_base_string
    end
  end

  # Returns a string zip code from an an address.
  def zip_code(address)
    match_data = address.match(/\b(\d{5})(?:-(\d{4}))?\b/o)
    match_data.nil? ? nil : match_data[0]
  end

  # Requests and returns weather data from https://api.weatherapi.com. Caches results for 30 mins.
  def request_forecast(zip)
    return zip_code_error_text if zip.nil?

    forecast = Rails.cache.read(zip, skip_nil: true)
    if forecast.nil?
      uri = URI("https://api.weatherapi.com/v1/current.json?key=#{weather_api_key}&q=#{zip}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.path + '?' + uri.query, {'Content-Type' => 'application/json'})

      response = http.request(request)
      forecast = JSON.parse(response.body)
      Rails.cache.write(zip, forecast, expires_in: 30.minutes)
      forecast['cached'] = false
      forecast
    else
      forecast['cached'] = true
      forecast
    end
  end
end
