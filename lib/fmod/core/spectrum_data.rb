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

      # @!attribute [r] length
      # @return [Integer] the number of entries in this spectrum window. Divide
      #   this by the output rate to get the hz per entry.
      # @since 0.9.2

      # @!attribute [r] channel_count
      # @return [Integer] the number of channels in the spectrum.
      # @since 0.9.2

      # @!attribute [r] spectrum
      # Values inside the float buffer are typically between 0.0 and 1.0.
      #
      # Each top level array represents one PCM channel of data.
      #
      # Address data as spectrum[channel][bin]. A bin is 1 FFT window entry.
      #
      # Only read/display half of the buffer typically for analysis as the 2nd
      # half is usually the same data reversed due to the nature of the way FFT
      # works.
      #
      # @todo Test for proper structure
      # @return [Array<Float>] per channel spectrum arrays.
      # @since 0.9.2

      [:length, :channel_count, :spectrum].each do |symbol|
        define_method(symbol) { self[symbol] }
      end
    end
  end
end