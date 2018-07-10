module FMOD
  module Core

    ##
    # Structure describing a float parameter for a DSP unit.
    class FloatDescription < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT]
        members = [:min, :max, :default, :mapping]
        super(address, types, members)
      end

      [:min, :max, :default, :mapping].each do |symbol|
        define_method(symbol) { self[symbol] }
      end
    end
  end
end