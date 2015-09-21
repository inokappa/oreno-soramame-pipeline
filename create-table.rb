#!/usr/bin/env ruby

require './lib/dynamodb'

table_name = ARGV[0]
# 
begin
  resp = create_table(table_name)
rescue
  print "Error: #$!\n"
else
  puts "Table " + resp.table_description.table_name + " created."
end
