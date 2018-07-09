module FMOD
  module Core
    class SpectrumData < Structure

      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, [TYPE_FLOAT, 32]]
        members = [:length, :channel_count, :spectrum]
        super(address, types, members)
      end
    end
  end
end