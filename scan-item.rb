#!/usr/bin/env ruby

require './lib/dynamodb'

#
# For debug
#
dynamodb_table = 'soramame'
p scan_item(dynamodb_table, '2015-09-16')
