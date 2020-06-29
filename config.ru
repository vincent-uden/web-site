require 'bundler'
Bundler.require

require_relative 'config/environment'
require_relative 'app'

require 'webrick/https'

Rack::Server.start(
  :Port => ENV['port'],
  :Host => '0.0.0.0',
  :Logger => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :app => App
)
