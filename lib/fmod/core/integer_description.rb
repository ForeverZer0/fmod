module FMOD
  module Core

    ##
    # Structure describing a integer parameter for a DSP unit.
    class IntegerDescription < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, TYPE_INT, TYPE_INT, TYPE_VOIDP]
        members = [:min, :max, :default, :infinite, :names]
        super(address, types, members)
      end

      # @!attribute min
      # @return [Integer] the minimum parameter value.

      # @!attribute max
      # @return [Integer] the maximum parameter value.

      # @!attribute default
      # @return [Integer] the default parameter value.

      [:min, :max, :default].each do |symbol|
        define_method(symbol) { self[symbol] }
      end

      ##
      # @return [Boolean] flag indicating if the last value represents infinity.
      def infinite?
        self[:infinite] != 0
      end

      ##
      # @return [Array<String>] the names for each value.
      def value_names
        return [] if self[:names].null?
        count = max - min + 1
        (0...count).map { |i| (self[:names] + (i * SIZEOF_INTPTR_T)).ptr.to_s }
      end
    end
  end
end