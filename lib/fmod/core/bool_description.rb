module FMOD
  module Core

    ##
    # Structure describing a boolean parameter for a DSP unit.
    class BoolDescription < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        super(address, [TYPE_INT, TYPE_VOIDP], [:default, :names])
      end

      # @!attribute [r] default
      # @return [Boolean] the default value for the parameter.
      def default
        self[:default] != 0
      end
    end
  end
end