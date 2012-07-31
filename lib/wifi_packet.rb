require 'delegate'
require 'active_support/core_ext/class/delegating_attributes'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'packetfu'
require 'wifi_beacon'
require 'pp'

class WifiPacket
  # Max MPDU size is 2346 bytes, payload size varies according to encryption scheme
  MAX_SIZE = 2346

  TYPE_MGMT = 0
  SUBTYPE_MGMT_BEACON = 0x08

  TYPE_CTRL = 1
  TYPE_DATA = 2
  
  attr_accessor :frame_ctrl, :duration, :address_1, :address_2, :address_3 
  attr_accessor :seq_ctrl, :address_4, :frame_body, :fcs
  attr_accessor :src_addr, :dst_addr, :xmit_addr, :rcvr_addr

  # Frame control fields
  attr_accessor :flags, :order, :wep, :more_data, :power, :retry 
  attr_accessor :more_frag, :from_ds, :to_ds, :frame_type, :frame_subtype, :protocol
  
  # Payload fields
  attr_accessor :beacon, :start, :radio_tap, :size

  # PLCP header (data after preamble and before MAC PDU)
  # Only radiotap is supported right now
  attr_accessor :radio_tap

  def read(str)
    PacketFu.force_binary(str)    
    @size            = str.bytesize
    @start           = str[2,2].unpack("S").first
    #print "start: "; pp str[2,2].bytes.to_a
    #print "start: "; pp str[2,2].unpack("S").first

    @protocol        = (str[start].ord & 0b00000011) 
    @frame_type      = (str[start].ord & 0b00001100) >> 2 
    @frame_subtype   = (str[start].ord & 0b11110000) >> 4

    @flags           = str[start+1]
    @to_ds           = (str[start+1].ord & 0b00000001) == 0b00000001 ? 1 : 0 
    @from_ds         = (str[start+1].ord & 0b00000010) == 0b00000010 ? 1 : 0
    @more_frag       = (str[start+1].ord & 0b00000100) == 0b00000100 ? 1 : 0 
    @retry           = (str[start+1].ord & 0b00001000) == 0b00001000 ? 1 : 0 
    @power           = (str[start+1].ord & 0b00010000) == 0b00010000 ? 1 : 0   
    @more_data       = (str[start+1].ord & 0b00100000) == 0b00100000 ? 1 : 0
    @wep             = (str[start+1].ord & 0b01000000) == 0b01000000 ? 1 : 0   
    @order           = (str[start+1].ord & 0b10000000) == 0b10000000 ? 1 : 0     

    @duration        = str[start+2,2].unpack("S").first
    @address_1       = str[start+4,6]
    @address_2       = str[start+10,6]
    @address_3       = str[start+16,6]
    @seq_ctrl        = str[start+22,2]
    @fcs             = str[-32,32]
    
    if beacon?
      @xmit_addr = @address_3
      @src_addr  = @address_2
      @dst_addr  = @address_1
      
      @body_size  = @size - (start + 24) + 1
      @frame_body = str[start+24..@size-1]      
      @beacon     = WifiBeacon.new.read(@frame_body)
    else
      @address_4  = str[start+24,6]
      @body_size  = @size - (start + 30) + 1
      @frame_body = str[start+30..@size-1]
    end
    
    self
  end

  def str2mac(str)
    PacketFu::EthHeader.str2mac(str).upcase unless str.nil? || str.empty?
  end

  def to_s
    # str = "start=%02d size=%d type=%d subtype=%d flags=%08b src=%13s dst=%13s duration=%d " % 
    #       [start, size, frame_type, frame_subtype, flags, 
    #        str2mac(src_addr), str2mac(dst_addr), duration]    
    # str << beacon.to_s if beacon?
    str = "start=#{start} size=#{size} "
    str << beacon.to_s if beacon?
  end

  def management?
    frame_type == TYPE_MGMT    
  end
  
  def beacon?
    management? && frame_subtype == SUBTYPE_MGMT_BEACON
  end
  
  def has_addr?(addr)
    [src_addr,dst_addr,xmit_addr,rcvr_addr].include?(addr)
  end
  
  def src_mac
    str2mac(self.src_addr)
  end

  def dst_mac
    str2mac(self.src_addr)
  end

  def ssid
    beacon.try(:ssid)
  end
  
end
