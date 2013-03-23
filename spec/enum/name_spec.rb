describe Enum do
  describe 'using names' do
    
    # Sample for use below
    module NameTest
      enum :a_long_key, 1
      enum :custom_name, 2, 'Wahoo'
      enum :singleton, 3
    end

    it 'should return a name from a value' do
      NameTest.name(3).should == 'Singleton'
    end
    
    it 'should return all names in order' do
      NameTest.names.should == ['A Long Key', 'Wahoo', 'Singleton']
    end
    
    it 'should return a set of names from a set of keys or values' do 
      NameTest.names(2, 1, :singleton).should == ['Wahoo', 'A Long Key', 'Singleton']
    end
    
    it 'should return nil for the name of nil' do
      NameTest.name(nil).should be_nil
    end
    
    it 'should keep normal Module#name behavior' do
      NameTest.name.should == 'NameTest'
    end
    
  end
end
