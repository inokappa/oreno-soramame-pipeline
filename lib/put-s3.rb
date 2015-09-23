#!/usr/bin/env ruby

require 'aws-sdk-resources'

def s3
  Aws.config[:region] = ENV['AWS_REGION']
  Aws::S3::Resource.new
end

def put_objects_s3(file_name, date, check_station_code, title, json_data)
  urls = []
  #
  key = File.basename(file_name)
  png = s3.bucket(ENV['S3_BUCKET']).object("#{date}/#{key}")
  png.upload_file(file_name)
  urls << png.public_url(virtual_host: true)
  #
  json = s3.bucket(ENV['S3_BUCKET']).object("#{date}/#{date}-#{check_station_code}-#{title}.json")
  json.put(body:json_data)
  urls << json.public_url(virtual_host: true)
end

def put_graph_s3(file_name, date, json_data)
  key = File.basename(file_name)
  obj = s3.bucket(ENV['S3_BUCKET']).object("#{date}/#{key}")
  obj.upload_file(file_name)
  obj.public_url(virtual_host: true)
end

def put_json_s3(json_data, date, title, check_station_code)
  obj = s3.bucket(ENV['S3_BUCKET']).object("#{date}/#{date}-#{check_station_code}-#{title}.json")
  obj.put(body:json_data)
  obj.public_url(virtual_host: true)
end

def put_html_s3(file_name)
  key = File.basename(file_name)
  obj = s3.bucket(ENV['S3_BUCKET']).object("kyusyu/#{key}")
  obj.upload_file(file_name)
  obj.public_url(virtual_host: true)
end
