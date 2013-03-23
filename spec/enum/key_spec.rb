describe Enum do
  describe 'with keys' do

    module KeyTest
      enum :key1, 10
      enum :key2, 20
      enum :key3, 5000
    end
    
    it 'should set enum keys as constants' do
      KeyTest::KEY1.should == 10
    end
    
    it 'should convert values to keys' do
      KeyTest.key(20).should == :key2
    end
    
    it 'should return a list of all keys' do
      KeyTest.keys.should == [:key1, :key2, :key3]
    end

  end
end
