module FMOD
  module Core

    ##
    # Structure describing a data parameter for a DSP unit.
    class DataDescription < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        super(address, [TYPE_INT], [:data_type])
      end

      def data_type
        self[:data_type]
      end
    end
  end
end