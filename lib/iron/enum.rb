# Provides enumerated value support for use as magic constants (status flags, types, etc...)
#
# Sample usage:
#
# Enum.enable_support(:all)
# module Fruit
#   enum :apple, 1
#   enum :pear,  2
# end
#
# Yields:
#
# Fruit::APPLE => 1
# Fruit.name(1) => 'Apple'
# Fruit.keys => [:apple, :pear]
# etc...
#
module Enum

  # Indexes into our definition list
  KEY_IDX = 0
  VALUE_IDX = 1
  NAME_IDX = 2

  # Legacy method of enum creation.  Call with a set of arrays, one for each desired enum.  Arrays should
  # contain the parameters supported by #enum, e.g. [:key, <value>, "<optional name>"]
  def define_enum(*items)
    items.each do |item|
      enum(*item)
    end
  end

  # Add an enumerated constant to the given module/class.  The key should be a symbol, the value a fixed integer
  # that the symbol represents.  The name is an optional user-friendly name for the enum, which will efault to
  # a capitalized version of the key.
  #
  # Sample usage:
  #
  #   module HTTPCode
  #     enum :success, 200
  #     enum :missing, 404
  #     enum :error,   500, 'Server Error'
  #   end
  def enum(key, value, name = nil)
    # Make sure we have our enum stuff in here
    self.extend(Enum::Core) unless respond_to?(:enum_list)

    # Validate input
    raise "Invalid enum key: #{key.inspect}" unless key.is_a?(Symbol)
    raise "Invalid enum value: #{value.inspect}" unless value.is_a?(Fixnum)
    raise "Invalid enum name: #{name.inspect}" unless name.nil? || name.is_a?(String)
    
    # Set our constant
    const_set(key.to_s.upcase, value)
    
    # Ensure we have a valid name
    name ||= key.to_s.split('_').collect(&:capitalize).join(' ')
    
    # Save to our list
    enum_list << [key, value, name]
  end

end

# Require additional files
require_relative './enum/core'
require_relative './enum/attr_support'
require_relative './enum/model_support'

# Bind to Module to enable #define_enum, #enum_attr and friends
Module.send(:include, Enum)
Module.send(:include, Enum::AttrSupport)

# Add our ActiveRecord extensions if we're in Rails
if defined?(ActiveRecord) 
  ActiveRecord::Base.send(:include, Enum::ModelSupport)
end