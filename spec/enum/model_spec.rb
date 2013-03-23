describe Enum do
  describe 'model attributes' do
    
    module AREnum
      enum :one, 1
      enum :two, 2
      enum :thirty_three, 33
    end
    
    module AnotherEnum
      enum :yo, 10
      enum :bob, 20
    end
    
    class ARTest < ActiveRecord::Base
      enum_attr :enum_field => AREnum, :another_enum => AnotherEnum
    end
    
    before do
      @test = ARTest.new
    end
    
    it 'should allow setting values by key' do
      @test.enum_field = :two
      @test.enum_field.should == 2
    end
    
    it 'should allow testing for a given value via method call' do
      @test.enum_field = AREnum::ONE
      @test.enum_field_one?.should be_true
    end
    
    it 'should allow setting a field to a value via method call' do
      @test.enum_field_two!
      @test.enum_field.should == 2
    end
    
    it 'should show enum values in inspect as full definition' do
      @test.enum_field = :two
      @test.inspect.should match(/AREnum::TWO/)
    end
    
    it 'should define a with_<enum field> scope' do
      ARTest.should respond_to(:with_enum_field)
    end
    
    it 'should find models with the provided scope' do
      ARTest.delete_all
      ARTest.create!(:enum_field => :two)
      ARTest.create!(:enum_field => :two)
      ARTest.with_enum_field(2).count.should == 2
    end
    
    it 'should support multiple values in the automatic scope' do
      ARTest.delete_all
      ARTest.create!(:enum_field => :two)
      ARTest.create!(:enum_field => 33)
      ARTest.with_enum_field(2, :thirty_three).count.should == 2
      ARTest.with_enum_field([2, :thirty_three]).count.should == 2
    end
    
    it 'should return no models for empty scope' do
      ARTest.delete_all
      ARTest.create!(:enum_field => nil)
      ARTest.create!(:enum_field => 2)
      ARTest.with_enum_field([]).count.should == 0
    end
    
    it 'should return models with null values for nil scope' do
      ARTest.delete_all
      ARTest.with_enum_field(nil).count.should == 0
      ARTest.create!(:enum_field => nil)
      ARTest.create!(:enum_field => 2)
      ARTest.create!(:enum_field => 2)
      ARTest.with_enum_field(nil).count.should == 1
    end
    
  end
end