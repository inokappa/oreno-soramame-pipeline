#!/usr/bin/env ruby

require 'aws-sdk'
require 'json'
require 'logger'
require './lib/put-s3'
require './lib/plot-graph'
require './lib/generate-json'

def dynamodb
  endpoint = 'http://' + ENV['DYNAMO_PORT_7777_TCP_ADDR'] + ':7777'
  # puts endpoint
  Aws::DynamoDB::Client.new(
    endpoint: endpoint, 
    # access_key_id: ENV['AWS_ACCESS_KEY'],
    # secret_access_key: ENV['AWS_SECRET_KEY'], 
    region: ENV['AWS_REGION'] 
  )
end

def logging
  Logger.new(STDOUT)
end

def post_to_dynamodb(table, data)
  result = dynamodb.put_item(
    table_name: table,
    item: {
      'mon_st_code' => data['mon_st_code'],
      'CHECK_DATE_TIME' => data['CHECK_DATE_TIME'],
      'document' => data.to_json
    }
  )
end

def list_tables
  result = dynamodb.list_tables
  result.table_names.each do |table|
    puts table
  end
end

def create_table(table_name)
  table = dynamodb.create_table({
    table_name: table_name ,
    key_schema:[
      {
        attribute_name: "mon_st_code",
        key_type: "HASH"
      },
      {
        attribute_name: "CHECK_DATE_TIME",
        key_type: "RANGE"
      },
    ],
    attribute_definitions: [
      {
        attribute_name: "CHECK_DATE_TIME",
        attribute_type: "S",
      },
      {
        attribute_name: "mon_st_code",
        attribute_type: "S",
      },
    ],
    provisioned_throughput: {
      read_capacity_units: 50,
      write_capacity_units: 50,
    },
  })
end

def delete_table(table_name)
  resp = dynamodb.delete_table({
    table_name: table_name
  })
end

def query_item(table_name, mon_st_code, check_date_time, date)
  result = dynamodb.query({
    table_name: table_name,
    select: "ALL_ATTRIBUTES", 
    key_condition_expression: "mon_st_code = :v_mon_st_code and CHECK_DATE_TIME >= :v_check_date_time",
    expression_attribute_values: {
      ":v_mon_st_code" => mon_st_code,
      ":v_check_date_time" => check_date_time,
    },
  })
  
  # p result.last_evaluated_key
  data_points = []
  check_points = []
  check_station_code = ""
  check_station = ""
  parsed_item = ""

  result.items.each do |item|
    parsed_item = JSON.parse(item['document'])
    #
    check_points << parsed_item['CHECK_TIME']
    data_points << parsed_item['PM2.5'].to_f
    #
    check_station_code = item['mon_st_code']
    check_station = parsed_item['mon_st_name']
    #
    logging.info("#{date} - #{parsed_item['CHECK_TIME']} / #{check_station} / #{parsed_item['PM2.5'].to_f}")
  end

  generate_data(check_points, data_points, 'PM2.5', check_station, check_station_code, date)
end

def get_mon_st_codes(table_name, check_date_time)
  result = []
  result1 = dynamodb.scan(
    table_name: table_name,
    select: "SPECIFIC_ATTRIBUTES",
    attributes_to_get: ["mon_st_code"],
  )

  if result1.last_evaluated_key then
    result2 = dynamodb.scan(
      table_name: table_name,
      select: "SPECIFIC_ATTRIBUTES",
      attributes_to_get: ["mon_st_code"],
      exclusive_start_key: { "CHECK_DATE_TIME"=>result1.last_evaluated_key['CHECK_DATE_TIME'], "mon_st_code" => result1.last_evaluated_key['mon_st_code'] }
    )
    result = result1.items.concat(result2.items)
  else
    result = result1.items
  end

  codes = []
  result.each do |item|
    codes << item['mon_st_code']
  end
  return codes.uniq
end

#
# For debug
#
def count_item(table_name)
  result = dynamodb.scan(
    table_name: table_name,
    select: "ALL_ATTRIBUTES", 
  )
  return result.items.count
end
