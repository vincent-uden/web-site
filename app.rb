require_relative './config/environment'

class App < Sinatra::Base
  enable :sessions

  before do
    nil
  end

  not_found do
    nil
  end

  get '/' do
    slim :index
  end

  get '/css_test' do
    slim :css_test
  end

  get '/css/*.css' do |var|
    scss ('scss/' + var).to_sym
  end
end
