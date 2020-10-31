require_relative './config/environment'


class App < Sinatra::Base
  enable :sessions


  before do
    if not session[:user_id]
      SiteStats.add_visitor
      session[:user_id] = 1
      dp request.env["REMOTE_ADDR"]
      Connections.log_connection request.env["REMOTE_ADDR"]
    end
    @quote = Quotes.random
    Routes.log_route request.env["PATH_INFO"]
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

  get '/acs' do
    slim :acs
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

  get '/quotes' do
    @quotes = Quotes.get_all
    slim :quotes
  end

  get '/admin' do
    @visits = SiteStats.get.get_visits
    @req_data = $formatter.format(request.env)
    @history = Connections.history
    slim :admin
  end

  post '/admin_auth' do
    hash = BCrypt::Password.new "$2a$12$a.F6mM6TAL/j5rSBOQBxqOjtRWAeFe0f2.aWCQWIddAu/BpFoUcwG"
    dp params["password"]
    if hash == params["password"]
      session['admin_auth'] = true
    end
    redirect back
  end

  post '/shutdown' do
    if session['admin_auth']
      Process.kill 'TERM', Process.pid
    end
  end

  post '/ml_update' do
    hash = BCrypt::Password.new "$2a$12$6T2nxr45oyj.Hfi7dfTPY.0.jte.b9FjGGUsGPHxItTqE3zGQxYMS"
    if hash == params["password"]
      $ml_status[:status] = params["status"]
      $ml_status[:msg] = params["msg"]
    end
    redirect back
  end

end
