#!/usr/bin/env ruby

require 'logger'
require './lib/dynamodb'
require './lib/generate-html'

def logging
  Logger.new(STDOUT)
end

table_name = ARGV[0]
date = Date.today - 1
# date = (Date.today - 1).strftime("%Y%m%d")
#
# For Debug
#
# urls = query_item('soramame', '40101010', '2015-03-12')
# generate_html(urls.split)

#
# Get mon_st_codes from DynamoDB
#
codes = get_mon_st_codes(table_name, date.strftime("%Y-%m-%d"))

#
# Upload image and generate image URL.
#
logging.info("Query from DynamoDB Local...")
urls = []
codes.each do |code|
  urls << query_item(table_name, code, date.strftime("%Y-%m-%d"), date.strftime("%Y%m%d"))
end

#
# Generage HTML
#
url = generate_html(urls, date.strftime("%Y-%m-%d"))
logging.info("result_url: " + url)
