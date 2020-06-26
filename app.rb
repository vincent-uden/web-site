require_relative './config/environment'

class App < Sinatra::Base
  enable :sessions

  before do
    if not session[:user_id]
      SiteStats.add_visitor
      session[:user_id] = 1
    end
  end

  not_found do
    nil
  end

  get '/' do
    slim :index
  end

  get '/css_test' do
    @visits = SiteStats.get.get_visits
    slim :css_test
  end

  get '/css/*.css' do |var|
    scss ('scss/' + var).to_sym
  end
end
