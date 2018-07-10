module FMOD
  module Core

    ##
    # Describes spectrum values between 0.0 and 1.0 for each "FFT bin".
    class SpectrumData < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, [TYPE_FLOAT, 32]]
        members = [:length, :channel_count, :spectrum]
        super(address, types, members)
      end
    end
  end
end