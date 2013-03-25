describe Enum do
  describe 'using options' do
    
    # Sample for use below
    module OptionTest
      enum :alpha, 5
      enum :beta,  10
      enum :gamma, 20, 'Monkeys'
    end

    it 'should return name + values as options array' do
      OptionTest.options.should == [['Alpha', 5], ['Beta', 10], ['Monkeys', 20]]
    end
    
    it 'should enable getting options array subset' do
      OptionTest.options(:gamma, :beta).should == [['Monkeys', 20], ['Beta', 10]]
    end
    
    it 'should return no options for nil' do
      OptionTest.options(nil).should == []
    end
    
    it 'should return no options for empty set' do
      OptionTest.options([]).should == []
    end
    
  end
end
