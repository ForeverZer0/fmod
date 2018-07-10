
module FMOD
  module Core

    ##
    # @abstract
    # Expands upon a the built-in Fiddle::CStructEntity to provide some
    # additional common functionality for FMOD structures.
    class Structure < Fiddle::CStructEntity

      include Fiddle
      include FMOD::Core

      ##
      # @param address [Integer, String] The memory address of the structure as
      #   an integer or packed binary string.
      # @param types [Array<Integer>] Array of primitive C-type flags for the
      #   data type used by each field.
      # @param members [Array<Symbol>] Array of names as symbols to use for the
      #   fields.
      def initialize(address, types, members)
        address = Pointer[address] if address.is_a?(String)
        address ||= Fiddle.malloc(self.class.size(types)).to_i
        super(address, types)
        assign_names members
      end

      ##
      # @return [Array<Symbol>] the names of the structure's fields as symbols.
      # @since 0.9.1
      def names
        @members
      end

      ##
      # @return [Array<Object>] the values of the structure's fields.
      # @since 0.9.1
      def values
        @members.map { |sym| self[sym] }
      end

      ##
      # @return [String] the structure as a string.
      def inspect
        values = @members.map { |sym| "#{sym}=#{self[sym]}"}.join(', ')
        super.sub(/free=0x(.)*/, values << '>')
      end
    end
  end
end