#!/usr/bin/env ruby
# If you have MetaSploit 3 installed you can run it using their included Ruby
require 'rubygems'
#require 'racket'
require 'pcaprub'

capture = Pcap.open_live("mon0",1344, true, 1)
capture.each do |packet|
  puts "#{packet}"
  puts
end

#capture.close


