require 'iphone_backup_manifest_format'

def read_iphone_backup_manifest(path = '.')
  File.open path+'/Manifest.mbdx', 'r' do |io_index|
    File.open path+'/Manifest.mbdb', 'r' do |io_data|
      index_header = IndexHeader.read(io_index)
      data_header = DataHeader.read(io_data)
      
      records = index_header.record_count.times.map do
        
        index = IndexRecord.read(io_index)
        io_data.seek data_header.num_bytes + index.data_offset
        data = DataRecord.read(io_data)
        
        [index.key_hex, data]
      end
      raise "Unexpected data at end of index" unless io_index.eof?
      
      Hash[records]
    end
  end
end
