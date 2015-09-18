#!/usr/bin/env ruby

require 'erb'

def generate_html(urls, date)
  result = ERB.new(File.read('template/template.html.erb')).result(binding)
  html_file = "output/html/#{date}.html"
  File.open(html_file, "w") do |file|
    file.puts result
  end
  put_html_s3(html_file)
end
