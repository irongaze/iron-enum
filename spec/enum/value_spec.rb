describe Enum do
  describe 'using values' do

    # Sample for use below
    module ValueTest
      enum :alpha, 5
      enum :beta, 10, 'a label'
      enum :gamma, 2
    end

    it 'should return a value as that value' do
      ValueTest.value(5).should == 5
    end
  
    it 'should convert keys to values' do
      ValueTest.value(:beta).should == 10
    end
  
    it 'should return nil for the value of nil' do
      EnumTest.value(nil).should be_nil
    end
    
    it 'should return all values' do
      ValueTest.values.should == [5, 10, 2]
    end
    
    it 'should return select values' do
      ValueTest.values(:alpha, :gamma).should == [5, 2]
    end
  
  end
end