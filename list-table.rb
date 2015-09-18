#!/usr/bin/env ruby

require './lib/dynamodb'

begin
  list_tables
rescue
  print "Error: #$!\n"
end
