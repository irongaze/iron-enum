describe Enum do

  # Sample for use below, using old declaration syntax
  class EnumTest
    define_enum(
      [:alpha, 5],
      [:beta, 10, 'A label'],
      [:gamma, 2]
    )
  end
  
  it 'should provide #define_enum and #enum on Module' do
    Module.should respond_to(:define_enum)
    Module.should respond_to(:enum)
  end
  
  it 'should add enums to the enum list on calling #enum' do
    count = EnumTest.enum_list.count
    EnumTest.enum(:epsilon, 22)
    EnumTest.enum_list.count.should == count + 1
    EnumTest.value(:epsilon).should == 22
  end
  
  it 'should test the validity of values' do
    EnumTest.valid_value?(10).should be_true
    EnumTest.valid_value?(555).should be_false
  end

end