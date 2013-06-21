module Enum

  # Provides helper methods to integrate enumerated constants (Enum) into your model layer.  Given an enum
  # defined like so:
  #
  #   module UserType
  #     enum :guest,  0
  #     enum :member, 1
  #     enum :admin,  2
  #   end 
  #
  # To add an enumerated value to a Rails model, simply add a column of type :integer to your model, then
  # declare it like so:
  #
  #   class User < ActiveRecord::Base
  #     enum_attr :user_type => UserType
  #   end
  #
  # When using non-model classes, it's the same syntax:
  #
  #   class User
  #     enum_attr :user_type => UserType
  #   end
  #
  # This will tell your class/model that the user_type attribute contains values from the UserType enum, and
  # will add:
  #
  #   @user.user_type => integer value or nil
  #   @user.user_type_admin? => true if object's user_type value == UserType::ADMIN
  #   @user.user_type_admin! => set the object's user_type to be UserType::ADMIN (does not save model!)
  #   @user.user_type_as_key => returns the key form of the current field value, eg :member
  #   @user.user_type_as_name => returns text name of the current field's value, eg 'Guest'
  #
  # In addition, you can set enum attributes via key, eg:
  #
  #   @user.user_type = :admin
  #
  # and the key will be converted to a value on the fly.
  #
  # ActiveRecord models get a few extras.  To start, each enum attribute will add a smart scope:
  #
  #   User.with_user_type(UserType::MEMBER) => scope returning a relation selecting User instances where user_type's value == UserType::MEMBER
  #
  # In addition, enum attributes will show up in #inspect output as e.g. UserType::GUEST instead of 0.
  module AttrSupport

    # Call with enum_attr :field => Enum
    def enum_attr(field_to_enum_map)
      # Save off the attr map
      @enum_attrs ||= {}
      @enum_attrs.merge!(field_to_enum_map)

      # Run each newly added enum attribute
      field_to_enum_map.each_pair do |attr_field, enum|
        # Convert Enum to "Enum"
        enum_klass = enum.to_s

        # Set up general use sugar - allows calling:
        #   attr_as_key to get back eg :production or :online instead of 1 or 5
        #   attr_as_name to get back eg "Production" or "Online"
        class_eval <<-eos, __FILE__, __LINE__ + 1
          def #{attr_field}_as_key
            #{enum_klass}.key(self.#{attr_field})
          end

          def #{attr_field}_as_name
            #{enum_klass}.name(self.#{attr_field})
          end
        eos

        # Get all the possible values for this enum in :key format (ie as symbols)
        enum.keys.each do |key|
          # Get the value for this key (ie in integer format)
          val = enum.value(key)

          # Build sugar for testing and setting the attribute's enumerated value
          class_eval <<-eos, __FILE__, __LINE__ + 1
            def #{attr_field}_#{key}?
              self.#{attr_field} == #{val}
            end

            def #{attr_field}_#{key}!
              self.#{attr_field} = #{val}
            end
          eos
        end

        if defined?(ActiveRecord) && self < ActiveRecord::Base

          # Define a finder scope
          scope "with_#{attr_field}", lambda {|*vals|
            vals.flatten!
            if vals.empty?
              where("?", false)
            elsif vals.count == 1
              where(attr_field => enum.value(vals.first))
            else
              where(attr_field => enum.values(vals))
            end
          }
          
          # Define a validation
          validates attr_field, :inclusion => { 
            :in => enum.values,
            :message => "%{value} is not a valid #{enum_klass} value",
            :allow_nil => true
          }

          # Override default setter to allow setting an enum attribute via key
          class_eval <<-eos, __FILE__, __LINE__ + 1
            def #{attr_field}=(val)
              write_attribute(:#{attr_field}, #{enum_klass}.value(val))
            end
          eos

        else 

          # Create getter/setter to allow setting an enum attribute via key
          class_eval <<-eos, __FILE__, __LINE__ + 1
            def #{attr_field}
              @#{attr_field}
            end

            def #{attr_field}=(val)
              val = nil if val.is_a?(String) && val.empty?
              @#{attr_field} = #{enum_klass}.value(val)
            end
          eos

        end

      end
    end

    # True if the given symbol maps to an enum-backed attribute
    def enum_attr?(name)
      return false unless @enum_attrs
      @enum_attrs.key?(name)
    end

    # Gets the enum class for a given attribute, or nil for none
    def enum_for_attr(name)
      return nil unless @enum_attrs
      @enum_attrs[name]
    end

  end
  
end