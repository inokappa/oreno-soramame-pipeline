#!/usr/bin/env ruby

require './lib/dynamodb'
require './lib/generate-html'

dynamodb_table = 'soramame'
date = (Date.today - 1).strftime("%Y%m%d")
#
# For Debug
#
# urls = query_item('soramame', '40101010', '2015-03-12')
# generate_html(urls.split)

#
# Get mon_st_codes from DynamoDB
#
codes = get_mon_st_codes(dynamodb_table, '2015-09-16')

#
# Upload image and generate image URL.
#
urls = []
codes.uniq.each do |code|
  urls << query_item(dynamodb_table, code, '2015-09-16', date)
end

#
# Generage HTML
#
p generate_html(urls, date)
