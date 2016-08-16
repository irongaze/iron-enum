describe Enum do
  describe 'using attributes' do
    
    module AttrTest
      enum :first, 1
      enum :second, 2
    end
    
    class AttrClass
      enum_attr :pos => AttrTest
      enum_attr :attr_test, :bob => AttrTest
    end
    
    before do
      @obj = AttrClass.new
    end
    
    it 'should support declaring enum attributes' do
      Module.should respond_to(:enum_attr)
      @obj.should respond_to(:attr_test_second?)
      @obj.should respond_to(:bob_as_name)
    end
    
    it 'should allow getting an attribute in key form' do
      @obj.pos = AttrTest::SECOND
      @obj.pos_as_key.should == :second
    end
    
    it 'should allow getting an attribute in name form' do
      @obj.pos = 1
      @obj.pos_as_name.should == 'First'
    end
    
    it 'should raise on setting invalid values' do
      expect { @obj.pos = 4000 }.to raise_error
    end
    
    it 'should convert strings that are ints to ints on setting values' do
      @obj.pos = '1'
      @obj.pos.should == 1
    end
    
    it 'should set empty strings as nil' do
      @obj.pos = ''
      @obj.pos.should be_nil
    end
    
    it 'should raise on setting to invalid strings' do
      expect {@obj.pos = 'abc'}.to raise_error
      expect {@obj.pos = '1a'}.to raise_error
    end
  
  end
end