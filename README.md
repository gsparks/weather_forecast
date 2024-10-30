# Dependencies
- ruby 3.3.5
- rails 7.2.1.2
- A valid https://www.weatherapi.com/ api key

# Usage
- `bundle install`
- Install your api key (see below).
- `rails s`
- Navigate to `localhost:3000`.

# Overview
This is a simple web page to retrieve and display weather data for a zip code. 

In addition to the boilerplate Rails code, I've added a root route for the index action of the `Forecast` controller. This action renders `app/views/forecast/index.html.erb` which offers a text field to enter an address as well as a button to retrieve weather data for that request. When pressed the button will call methods included from `app/helpers/forecast_helper.rb` to fetch, parse, cache, and print a forecast. Forecasts from the same zip code are cached for 30 minutes.

`app/helpers/forecast_helper.rb` is tested in `spec/app/helpers/forecast_helper_spec.rb`. The tests require a valid api key to run.

A valid api key needs to be stored as a rails secret under the `weather_api_key` entry. `Rails.application.credentials.weather_api_key`. Alternatively a key could be returned by the `weather_api_key` method in the forecast helper for quicker testing.

I opted for a small helper module to handle data fetching and formatting because we don't need to persist data with a model/ActiveRecord.

Thanks for reading!

# Tests
`bundle exec rspec spec`