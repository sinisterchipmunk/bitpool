module Bitpool::Target
  TARGET = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000
  # TARGET = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  # TARGET =   0x00000000ffff0000000000000000000000000000000000000000000000000000
  
  def uint32(i)
    i & 0xffffffff
  end
  
  def bytereverse(x)
    uint32((((x) << 24) | (((x) << 8) & 0x00ff0000) |
    		  	(((x) >> 8) & 0x0000ff00) | ((x) >> 24) ))
  end
  
  def bufreverse(target)
    result = ''
    (0...target.length).step(4) do |i|
      word = target[i...(i+4)].unpack('I')[0]
      result << [bytereverse(word)].pack("I")
    end
    result
  end
  
  def wordreverse(target)
    words = []
    (0...target.length).step(4) do |i|
      words << target[i...(i+4)]
    end
    result = ''
    words.reverse.each do |word|
      result << word
    end
    result
  end
  
  def hexbuf(target)
    result = ''
    for i in 0...target.length
      result += '%02x' % target[i..-1].unpack('C')[0]
    end
    result
  end
  
  def decode_hex(numeric)
    # why does this work but `numeric.to_s(16).rjust(64, '0').to_a.pack('H*')` does not?
    s = numeric
    if numeric.kind_of?(String)
      s = numeric
    else
      s = numeric.to_s(16)
    end
    s = s.rjust(64, '0')
    s = '0' + s if((s.length & 1) != 0)
    s.scan(/../).map{ |b| b.to_i(16) }.pack('C*')
  end
  
  def encode_hex(string)
    # see #decode_hex
    # string.unpack("H*").first.to_i(16)
    string.unpack('C*').map{ |b| "%02X" % b }.join('').to_i(16)
  end
  
  def targetstr(target)
    result = decode_hex(target)
    result = bufreverse(result)
    result = wordreverse(result)
    hexbuf(result)
  end
end
