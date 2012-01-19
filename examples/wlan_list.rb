#!/usr/bin/env ruby
$: << File.expand_path('../../lib',__FILE__)
require 'rubygems'
require 'bundler/setup'
require 'pcaprub'
require 'packetfu'
require 'wifi_packet'
require 'pp'

TARGET_AP_ADDR = PacketFu::EthHeader.mac2str("68:7F:74:A3:C0:C5")
BROADCAST_ADDR = PacketFu::EthHeader.mac2str("FF:FF:FF:FF:FF:FF")

packet_count = 0
ssid_list = {}
iface = ARGV[0] || 'mon0'

capture = Pcap.open_live(iface, 0xffff, true, 1)
trap("SIGINT") do
  puts; puts "capture ended ..."; pp ssid_list.keys; exit!
end

puts "capture started ..."
capture.each do |stream|
  packet = WifiPacket.new.read(stream)
  if packet.is_beacon?
    puts packet
    #File.open("packet#{'%02d'%packet_count}.bin","wb"){ |file| file.write stream }
    #File.open("packet#{'%02d'%packet_count}.txt","w"){ |file| file.puts packet }
    #packet_count+=1
    ssid_list[packet.beacon.ssid] = 1
  end
end


