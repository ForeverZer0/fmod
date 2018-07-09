module FMOD
  module Core
    class BoolDescription < Structure

      def initialize(address = nil)
        super(address, [TYPE_INT, TYPE_VOIDP], [:default, :names])
      end

      def default
        self[:default] != 0
      end

      def names
        %w(true false)
      end
    end
  end
end