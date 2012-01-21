shared_examples_for "Wifi Packet" do
  
  it "should have protocol version equal to zero" do
    @packet.protocol.should == 0
  end
  
  it "should have a valid frame type" do
    @packet.frame_type.should be >= 0
    @packet.frame_type.should be <= 3     
  end

  it "should have a valid frame sub-type" do
    @packet.frame_type.should be >= 0    
    @packet.frame_type.should be <= 15    
  end

  it "should have a valid source MAC address" do
    @packet.src_mac.should be_a_mac_address
  end

  it "should have a valid destination MAC address" do
    @packet.dst_mac.should be_a_mac_address
  end

end