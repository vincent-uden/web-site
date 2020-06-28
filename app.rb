require_relative './config/environment'

class App < Sinatra::Base
  enable :sessions

  before do
    if not session[:user_id]
      SiteStats.add_visitor
      session[:user_id] = 1
    end
    @quote = Quotes.random
  end

  not_found do
    status 404
    slim :'404', layout: false
  end

  get '/css/*.css' do |var|
    scss ('scss/' + var).to_sym
  end

  get '/' do
    slim :index
  end

  get '/css_test' do
    @visits = SiteStats.get.get_visits
    slim :css_test
  end

  get '/blog/archive' do
    @blog_posts = BlogPosts.get_post_groups
    slim :blog_archive
  end

  get '/blog/post/*' do |var|
    @post = BlogPosts.get_by_url "/blog/post/#{var}"
    slim "blog_posts/#{var}".to_sym
  end

  get '/contact' do
    slim :contact
  end

end
