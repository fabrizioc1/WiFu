#!/usr/bin/env ruby
# If you have MetaSploit 3 installed you can run it using their included Ruby
require 'rubygems'
#require "bundler/setup"
puts "lib: #{File.expand_path('../../lib',__FILE__)}"
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))
require 'pcaprub'
require 'racket'

capture = Pcap.open_live("mon0",1344, true, 1)
capture.each do |packet|
  p = Racket::L2::Ethernet.new(packet)
  puts "#{p.pretty}"
  puts
end

#capture.close


