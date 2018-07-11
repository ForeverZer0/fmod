module FMOD
  module Core

    ##
    # Structure describing a float parameter for a DSP unit.
    class FloatDescription < Structure

      ##
      # Values mapped linearly across range.
      LINEAR = 0

      ##
      # A mapping is automatically chosen based on range and units.
      AUTO = 1

      ##
      # Values mapped in a piecewise linear fashion.
      PIECEWISE_LINEAR = 2

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT]
        members = [:min, :max, :default, :mapping]
        super(address, types, members)
      end

      # @!attribute min
      # @return [Float] the minimum parameter value.

      # @!attribute max
      # @return [Float] the maximum parameter value.

      # @!attribute default
      # @return [Float] the default parameter value.

      # @!attribute mapping
      # Value indicating how the values are distributed across dials and
      # automation curves (e.g. linearly, exponentially etc).
      #
      # Will be one of the following values:
      # * {LINEAR}
      # * {AUTO}
      # * {PIECEWISE_LINEAR}
      # @return [Integer] the mapping type.

      [:min, :max, :default, :mapping].each do |symbol|
        define_method(symbol) { self[symbol] }
      end
    end
  end
end