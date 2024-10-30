require "rails_helper"
require_relative '../../../app/helpers/forecast_helper'

class IncludingClass
  include ForecastHelper
end

describe ForecastHelper do
  it 'loads' do
    expect(ForecastHelper).to be_a Module
  end

  let(:address) {
    '1945 SE Water Ave, Portland, OR 97214'
  }
  
  context 'with a valid api key' do
    context 'and a valid address' do
      it 'returns a correctly formatted forecast string with the correct location' do
        forecast = IncludingClass.new.get_forecast(address)
        expect(forecast).to match(/Temperature in Portland, Oregon is currently/)
      end
    end

    context 'and an address that is missing a zip code' do
      let(:address) {
        '1945 SE Water Ave, Portland, OR'
      }

      it 'returns a string instucting the user to enter a valid zip code.' do
        forecast = IncludingClass.new.get_forecast(address)
        expect(forecast).to eql('Please use an address with a valid zip code.')
      end
    end

    context 'and a blank address' do
      let(:address) {
        ''
      }

      it 'returns a string instucting the user to enter a valid zip code.' do
        forecast = IncludingClass.new.get_forecast(address)
        expect(forecast).to eql('Please use an address with a valid zip code.')
      end
    end

    context 'and a nil address' do
      let(:address) {
        nil
      }

      it 'returns an empty string.' do
        forecast = IncludingClass.new.get_forecast(address)
        expect(forecast).to eql('')
      end
    end
  end

  context 'with an invalid api key' do
    let(:bad_api_key) {
      'bad'
    }

    it 'passes the api error to the user' do
      allow_any_instance_of(IncludingClass).to receive(:weather_api_key).and_return(bad_api_key)
      forecast = IncludingClass.new.get_forecast(address)
      expect(forecast).to match('An error occurred: API key has been disabled.')
    end
  end
end
