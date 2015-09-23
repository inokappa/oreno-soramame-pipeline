#!/usr/bin/env ruby

require './lib/dynamodb'

table_name = ARGV[0]
begin
  resp = count_item(table_name)
rescue  
  print "Error: #$!\n"
else
  puts "Records: " + "#{resp}"
end
