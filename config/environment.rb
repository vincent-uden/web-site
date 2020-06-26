#!/usr/bin/env ruby

def dp(str)
    call = caller_locations(1,1)[0]
    path = call.path().split "web-site"
    path = path[1]
    print "#{path}:#{call.lineno} "
    p str
end

require_relative '../database/database'
require_relative '../database/models/tables'
require_relative '../database/models/site_stats'

puts '------------------'
puts '-   Restarting   -'
puts '------------------'

# Database.drop_tables ['site_stats']
# Database.create_tables ['site_stats']

# x = SiteStats.new({ "id" => 1, "visits" => 0 })
# x.save
