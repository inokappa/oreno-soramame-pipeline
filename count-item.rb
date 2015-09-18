#!/usr/bin/env ruby

require './lib/dynamodb'

begin
  resp = count_item('soramame')
rescue  
  print "Error: #$!\n"
else
  puts "Records: " + "#{resp}"
end
