#!/usr/bin/env ruby

require 'open-uri'
require 'uri'
require 'nokogiri'
require 'date'
require 'json'
require 'nkf'
require './lib/dynamodb'

#
# Get soramame content and call `post_to_dynamodb`
#
def get_soramame_content(uri, check_date_time, check_time)
  # Set Charset
  charset = nil
  # charset = 'UTF-8'
  
  # Get URI content
  #html = open(url) do |f|
  #  charset = f.charset
  #  f.read
  #end
  # html = NKF.nkf("--utf8", open(ARGV[0]).read)
  html = NKF.nkf("--utf8", open(uri).read)
  
  # Parse content and post to Dynamodb
  header = ['CHECK_DATE_TIME','CHECK_TIME','mon_st_code','town_name', 'mon_st_name', 'SO2','NO','NO2','NOX','CO','OX','NMHC','CH4','THC','SPM','PM2.5','SP','WD','WS','TEMP','HUM','mon_st_kind']
  doc = Nokogiri::HTML.parse(html, nil, charset)
  doc.xpath('//tr[td]').each do |tr|
    row = tr.xpath('td').map { |td| td.content.gsub(/[\u00A0\n]|\-\-\-/,'NA') }
    row.unshift(check_time)
    row.unshift(check_date_time)
    ary = [header,row].transpose
    h = Hash[*ary.flatten]
    # p h
    post_to_dynamodb('soramame', h)
  end
end

#
# Get soramame content(HTML)
#
def get_raw_soramame_content(uri)
  u = URI.parse(uri)
  html_file = u.path.split("/")
  open(uri) do |f|
    File.open("#{html_file[5]}", "w") do |html|
      html.puts(f.read)
    end
  end
end

#
# Main
#
d = (Date.today - 1)
(1..24).each do |h| 
  h = "%02d" % h
  check_date_time = d.strftime("%Y-%m-%d") + " #{h}:00:00"
  uri = 'http://soramame.taiki.go.jp/Gazou/Hyou/AllMst/' + d.strftime("%Y%m%d") + '/hb' + d.strftime("%Y%m%d") + h + '08.html'
  p uri
  p check_date_time
  # get_raw_soramame_content(uri)
  get_soramame_content(uri, check_date_time, h)
end

