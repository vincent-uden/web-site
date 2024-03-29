#!/usr/bin/env ruby

def dp(str)
    call = caller_locations(1,1)[0]
    path = call.path().split "web-site"
    path = path[1]
    print "#{path}:#{call.lineno} "
    p str
end

require 'net/http'
require 'json'
require 'date'

require_relative '../database/database'
require_relative '../database/models/tables'
require_relative '../database/models/site_stats'
require_relative '../database/models/blog_posts'
require_relative '../database/models/quotes'
require_relative '../database/models/connections'
require_relative '../database/models/countries'
require_relative '../database/models/routes'


puts '------------------'
puts '-   Restarting   -'
puts '------------------'

$ml_status = { status: "Idle", msg: "" }

$inspector = AwesomePrint::Inspector.new(plain: true)
$formatter = AwesomePrint::Formatter.new($inspector)

[ BlogPosts, Quotes, SiteStats, Connections, Countries, Routes ].each do |table|
  if !Database.table_exists? table.table_name
    Database.create_tables [table.table_name]
  end
end

Connections.history

class NilClass
  def include?(*args)
    false
  end

  def pop(*args)
    nil
  end

  def <<(*args)
    nil
  end
end

# Database.drop_tables ['site_stats']
# Database.create_tables ['site_stats']

# x = SiteStats.new({ "id" => 1, "visits" => 0 })
# x.save

# Database.drop_tables ['blog_posts']
# Database.create_tables ['blog_posts']
