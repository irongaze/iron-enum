describe Enum do
  describe 'using attributes' do
    
    module AttrTest
      enum :first, 1
      enum :second, 2
    end
    
    class AttrClass
      enum_attr :pos => AttrTest
    end
    
    before do
      @obj = AttrClass.new
    end
    
    it 'should support declaring enum attributes' do
      Module.should respond_to(:enum_attr)
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
    
  end
end