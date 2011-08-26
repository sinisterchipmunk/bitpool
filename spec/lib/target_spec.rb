require 'spec_helper'

describe Bitpool::Target do
  include Bitpool::Target
  
  it "bytereverse" do
    bytereverse(0).should == 0
    bytereverse(0xff ).should == 0xff000000
    bytereverse(0x1fe).should == 0xfe010000
    bytereverse(0x2fd).should == 0xfd020000
    bytereverse(0x3fc).should == 0xfc030000
    bytereverse(0x4fb).should == 0xfb040000
    bytereverse(0x5fa).should == 0xfa050000
    bytereverse(0x6f9).should == 0xf9060000
    bytereverse(0x7f8).should == 0xf8070000
    bytereverse(0x8f7).should == 0xf7080000
  end
  
  it "bufreverse" do
    bufreverse('0000').should == '0000'
    bufreverse('7bea84d5').should == 'aeb75d48'
    bufreverse('f61d4108').should == 'd16f8014'
    bufreverse('1712be18').should == '217181eb'
    bufreverse('1ec3a821').should == '3ce1128a'
    bufreverse('26749229').should == '47629229'
    bufreverse('2e257c31').should == '52e213c7'
    bufreverse('35d66639').should == '6d539366'
    bufreverse('3d875042').should == '78d32405'
    bufreverse('45383a4a').should == '8354a4a3'
  end
  
  it "wordreverse" do
    wordreverse('0000').should == '0000'
    wordreverse('7bea84d5').should == '84d57bea'
    wordreverse('f61d4108').should == '4108f61d'
    wordreverse('1712be18').should == 'be181712'
    wordreverse('1ec3a821').should == 'a8211ec3'
    wordreverse('26749229').should == '92292674'
    wordreverse('2e257c31').should == '7c312e25'
    wordreverse('35d66639').should == '663935d6'
    wordreverse('3d875042').should == '50423d87'
    wordreverse('45383a4a').should == '3a4a4538'
  end
  
  it "hexbuf" do
    hexbuf('0000').should == '30303030'
    hexbuf('7bea84d5').should == '3762656138346435'
    hexbuf('f61d4108').should == '6636316434313038'
    hexbuf('1712be18').should == '3137313262653138'
    hexbuf('1ec3a821').should == '3165633361383231'
    hexbuf('26749229').should == '3236373439323239'
    hexbuf('2e257c31').should == '3265323537633331'
    hexbuf('35d66639').should == '3335643636363339'
    hexbuf('3d875042').should == '3364383735303432'
    hexbuf('45383a4a').should == '3435333833613461'
  end

  it "targetstr" do
    targetstr(0x0).should == '0000000000000000000000000000000000000000000000000000000000000000'
    targetstr(0xe3a47257b073deac767bd2649dffc597b1a0c7ecaef08ce7c03e6937101001).should == '01101037693ec0e78cf0aeecc7a0b197c5ff9d64d27b76acde73b05772a4e300'
    targetstr(0x1c748e4af60e7bd58ecf7a4c93bff8b2f63418fd95de119cf807cd26e202002).should == '0220206ed27c80cf19e15dd98f41632f8bff3bc9a4f7ec58bde760afe448c701'
    targetstr(0x2aaed5707115b9c056373772dd9ff50c714e257c60cd1a6b740bb3ba5303003).should == '033030a53bbb40b7a6d10cc657e214c750ffd92d777363059c5b110757edaa02'
    targetstr(0x38e91c95ec1cf7ab1d9ef499277ff165ec6831fb2bbc2339f00f9a4dc404004).should == '044040dca4f9009f33c2bbb21f83c65e16ff779249efd9b17acfc15ec9918e03'
    targetstr(0x472363bb67243595e506b1bf715fedbf67823e79f6ab2c086c1380e13505005).should == '055050130e38c186c0b26a9fe72378f6dbfe15f71b6b505e594372b63b367204'
    targetstr(0x555daae0e22b7380ac6e6ee5bb3fea18e29c4af8c19a34d6e8176774a606006).should == '0660604a7776816e4da3198cafc4298ea1feb35beee6c60a38b7220eaeda5505'
    targetstr(0x6397f2065d32b16b73d62c0c051fe6725db657778c893da5641b4e081707007).should == '07707081e0b44156da93c8787765db2567fe51c0c0623db7162bd365207f3906'
    targetstr(0x71d2392bd839ef563b3de9324effe2cbd8d063f657784673e01f349b8808008).should == '088080b849f3013e678477653f068dbd2cfeef2493deb363f59e83bd92231d07'
    targetstr(0x800c805153412d4102a5a65898dfdf2553ea707522674f425c231b2ef909009).should == '099090efb231c225f474265207a73e55f2fd8d89655a2a10d412341505c80008'

    targetstr(0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF).should == "ffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000"
  end
  
  it "decode hex" do
    decode_hex(0x0100000081cd02ab7e569e8bcd9317e2fe99f2de44d49ab2b8851ba4a308000000000000e320b6c2fffc8d750423db8b1eb942ae710e951ed797f7affc8892b0f1fc122bc7f5d74df2b9441a42a14695)[0...80].should == "\x01\x00\x00\x00\x81\xcd\x02\xab~V\x9e\x8b\xcd\x93\x17\xe2\xfe\x99\xf2\xdeD\xd4\x9a\xb2\xb8\x85\x1b\xa4\xa3\x08\x00\x00\x00\x00\x00\x00\xe3 \xb6\xc2\xff\xfc\x8du\x04#\xdb\x8b\x1e\xb9B\xaeq\x0e\x95\x1e\xd7\x97\xf7\xaf\xfc\x88\x92\xb0\xf1\xfc\x12+\xc7\xf5\xd7M\xf2\xb9D\x1aB\xa1F\x95"
  end
  
  it "decode/encode hex" do
    encode_hex(decode_hex(0x0000)).should == 0x0000
    encode_hex(decode_hex(0x7bea84d5)).should == 0x7bea84d5
    encode_hex(decode_hex(0xf61d4108)).should == 0xf61d4108
    encode_hex(decode_hex(0x1712be18)).should == 0x1712be18
    encode_hex(decode_hex(0x1ec3a821)).should == 0x1ec3a821
    encode_hex(decode_hex(0x26749229)).should == 0x26749229
    encode_hex(decode_hex(0x2e257c31)).should == 0x2e257c31
    encode_hex(decode_hex(0x35d66639)).should == 0x35d66639
    encode_hex(decode_hex(0x3d875042)).should == 0x3d875042
    encode_hex(decode_hex(0x45383a4a)).should == 0x45383a4a
  end
end
