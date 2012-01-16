require 'packetfu'

class WifiBeacon
  
  attr_accessor :timestamp, :interval, :capabilities, :ssid, :ssid_tag, :ssid_len

  def read(str)
    PacketFu.force_binary(str)
    return self if str.nil? || str.bytesize < 12

    @timestamp    = str[0,8] 
    @interval     = str[8,2].unpack("S") 
    @capabilities = str[10,2]
    @ssid_tag     = str[12].ord
    @ssid_len     = str[13].ord
    @ssid         = str[14,@ssid_len]
    self
  end

  def to_s
    "ssid=#{ssid}"  
  end

end    
