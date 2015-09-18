#!/usr/bin/env ruby

require 'gchart'

def plot_graph(check_points, points, title, check_station, check_station_code, date)
  check_points = check_points.join("|")
  chart = Gchart.new( 
    :size => '350x200',
    :type => 'line',
    :title => "#{check_station} - #{title}" ,
    :theme => :greyscale,
    :data => [points], :max_value => 80,
    :axis_with_labels => ['x', 'y'],
    :axis_labels => [check_points, nil],
    :axis_range => [nil, [0,80,5]],
    :filename => "output/png/#{date}-#{check_station_code}-#{title}.png"
  )
  chart.file
  put_graph_s3(chart.filename, date)
end
