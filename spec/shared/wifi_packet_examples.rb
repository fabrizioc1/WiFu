require 'spec_helper'
require 'wifi_packet'

shared_examples_for "Wifi Packet" do
  
  it "should have protocol version equal to zero" do
    @packet.protocol.should == 0
  end
  
  it "should have a valid frame type" do
    @packet.frame_type.should be_integer
  end

  it "should have a valid frame sub-type" do
    @packet.frame_subtype.should be_integer
  end

  it "should have a valid source MAC address" do
    @packet.src_mac.should match(/^(?:[A-F0-9]{2}:){5}[A-F0-9]{2}$/)
  end

  it "should have a valid destination MAC address" do
    @packet.dst_mac.should match(/^(?:[A-F0-9]{2}:){5}[A-F0-9]{2}$/)
  end

end