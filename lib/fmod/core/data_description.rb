module FMOD
  module Core
    class DataDescription < Structure

      def initialize(address = nil)
        super(address, [TYPE_INT], [:data_type])
      end

      def data_type
        self[:data_type]
      end
    end
  end
end