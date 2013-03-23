module Enum

  # Provides ActiveRecord-specific functionality for enum attributes
  module ModelSupport

    # Provide pretty output of enumerated values in console, overrides
    # Rails' internal method for doing the same for AR models generally.
    def attribute_for_inspect(name)
      # Convert to symbol and get our current value
      name = name.to_sym
      val = self.send(name)

      # Check to see if we're non-nil and that this attribute is an enumeration attribute
      if val && self.class.enum_attr?(name)
        # Get the enum for this attribute
        enum = self.class.enum_for_attr(name)
        # Get the key version of the value
        key = enum.key(val)
        # Generate our pretty version in Enum::VALUE_KEY format
        "#{enum.to_s}::#{key.to_s.upcase}"

      else
        # Not an enum attr or nil - fall back on standard implementation
        super
      end
    end

  end

end