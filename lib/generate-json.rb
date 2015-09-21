#!/usr/bin/env ruby

require 'json'

def genarate_json(check_points, points, title, check_station, check_station_code, date)
  toJson = []
  toJson = [check_points, points].transpose
  h = Hash[*toJson.flatten]
  put_json_s3(h.to_json, date, 'PM2.5', check_station_code) 
end
