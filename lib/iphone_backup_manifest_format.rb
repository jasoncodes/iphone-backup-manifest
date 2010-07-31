require 'bindata'

# iTunes 9.2 iOS backup format
# based on spec at http://code.google.com/p/iphonebackupbrowser/wiki/MbdbMbdxFormat

class ManifestString < BinData::Primitive
  endian :big
  uint16 :len
  string :data,
    :read_length => :len,
    :read_length => lambda { |data| data.len },
    :onlyif => lambda { |data| data.len != 65535 }
  
  def get
    self.data
  end
  
end

class IndexHeader < BinData::Record
  endian :big
  string :magic, :read_length => 6, :check_value => "mbdx\002\000"
  uint32 :record_count
end

class IndexRecord < BinData::Record
  endian :big
  string :key_bytes, :read_length => 20
  uint32 :data_offset
  uint16 :mode
  
  def key_hex
    key_bytes.unpack('H*').join
  end
  
end

class DataHeader < BinData::Record
  endian :big
  string :magic, :read_length => 6, :check_value => "mbdb\005\000"
end

class DataProperty < BinData::Record
  endian :big
  manifest_string :name
  manifest_string :data
end

class DataPropertySet < BinData::Primitive
  endian :big
  uint8 :len
  array :properties, :type => :data_property, :initial_length => :len
  
  def get
    Hash[self.properties.map do |property|
      [property.name, property.data]
    end]
  end
  
end

class DataRecord < BinData::Record
  endian :big
  manifest_string :domain
  manifest_string :path
  manifest_string :link_target
  manifest_string :data_hash
  manifest_string :unknown1
  hide :unknown1
  uint16 :mode
  uint32 :unknown2
  hide :unknown2
  uint32 :unknown3
  hide :unknown3
  uint32 :user_id
  uint32 :group_id
  uint32 :time1
  uint32 :time2
  uint32 :time3
  uint64 :file_length
  uint8 :flag
  data_property_set :properties
end
