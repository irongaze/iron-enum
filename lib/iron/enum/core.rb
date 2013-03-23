module Enum
  module Core
    
    # List of enum data used for all other enum methods
    def enum_list
      @enum_list ||= []
      @enum_list
    end

    # Value for a given key or value
    def value(key)
      return nil if key.nil?
      row_for(key)[VALUE_IDX]
    end

    # Convert array of keys to an array of values
    def values(*included)
      rows_for(*included).collect {|row| row[VALUE_IDX]}
    end

    # True if a valid value (not key!), false if not
    def valid_value?(val)
      return values.include?(val)
    end

    # Key for a given key or value
    def key(key)
      return nil if key.nil?
      row_for(key)[KEY_IDX]
    end

    # Convert an array of values into an array of keys
    def keys(*included)
      rows_for(*included).collect {|row| row[KEY_IDX]}
    end

    # Name for a given key/value
    def name(key = :_no_value_)
      return nil if key.nil?
      return super() if key == :_no_value_
      row_for(key)[NAME_IDX]
    end

    # Convert arrays of keys/values into an array of names
    def names(*included)
      rows_for(*included).collect {|row| row[NAME_IDX]}
    end

    # Used for select tag options, optionally pass set of keys/ids to include, eg if there are only
    # a subset that would be valid for selection in a given context.
    def options(*included)
      included.flatten!
      if included.empty?
        # All options
        enum_list.collect {|row| option_for(row.first)}
      else
        # Only the specified ones
        included.collect {|key| option_for(key)}.compact
      end
    end

    # Array in order required by select fields
    def option_for(key)
      opt = [name(key), value(key)]
    end

    # Override inspect on the enum module to give a pretty listing
    def inspect
      values.collect do |v|
        "#{self.to_s}::#{key(v).to_s.upcase} => #{v}"
      end.join("\n")
    end

    private

    def to_key(id)
      return id if id.is_a?(Symbol)
      row = enum_list.find {|row| row[VALUE_IDX] == id}
      row.nil? ? nil : row[KEY_IDX]
    end

    def row_for(in_key)
      key = to_key(in_key)
      row = enum_list.find {|r| r[KEY_IDX] == key}
      raise "No information on key [#{in_key.inspect}] in enum #{self}" unless row
      row
    end

    def rows_for(*included)
      included.flatten!
      if included.empty?
        # All enums
        enum_list
      else
        # Only the specified ones
        included.collect {|key| row_for(key)}.compact
      end
    end
    
  end
end