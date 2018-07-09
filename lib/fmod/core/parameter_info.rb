module FMOD
  module Core
    class ParameterInfo < Structure

      include Fiddle

      def initialize(address = nil)
        types = [TYPE_INT, [TYPE_CHAR, 16], [TYPE_CHAR, 16], TYPE_VOIDP, TYPE_VOIDP]
        members = [:type, :name, :label, :description, :info]
        super(address, types, members)
      end

      def type
        self[:type]
      end

      def name
        (self + SIZEOF_INT).to_s(16).delete("\0").force_encoding('UTF-8')
      end

      def label
        (self + SIZEOF_INT + 16).to_s(16).delete("\0")
      end

      def description
        self[:description].to_s
      end

      def info
        pointer = self + SIZEOF_INT + (SIZEOF_CHAR * 32) + SIZEOF_INTPTR_T
        case self[:type]
        when ParameterType::FLOAT then FloatDescription.new(pointer)
        when ParameterType::INT then IntegerDescription.new(pointer)
        when ParameterType::BOOL then BoolDescription.new(pointer)
        when ParameterType::DATA then DataDescription.new(pointer)
        else raise RangeError, "Invalid data type for parameter."
        end
      end
    end
  end
end