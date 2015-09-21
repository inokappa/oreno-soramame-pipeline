#!/usr/bin/env ruby

require './lib/dynamodb'

#
# For debug
#
table_name = ARGV[0]
puts scan_item(table_name, '2015-09-19')
