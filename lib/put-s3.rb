#!/usr/bin/env ruby

require 'aws-sdk-resources'

def s3
  Aws.config[:region] = ENV['AWS_REGION']
  Aws::S3::Resource.new
end

def put_graph_s3(file_name, date)
  key = File.basename(file_name)
  obj = s3.bucket(ENV['S3_BUCKET']).object("#{date}/#{key}")
  obj.upload_file(file_name)
  obj.public_url(virtual_host: true)
end

def put_html_s3(file_name)
  key = File.basename(file_name)
  obj = s3.bucket(ENV['S3_BUCKET']).object("kyusyu/#{key}")
  obj.upload_file(file_name)
  obj.public_url(virtual_host: true)
end
