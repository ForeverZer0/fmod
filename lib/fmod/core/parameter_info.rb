module FMOD
  module Core

    ##
    # Base Structure for DSP parameter descriptions.
    class ParameterInfo < Structure

      include Fiddle

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, [TYPE_CHAR, 16], [TYPE_CHAR, 16], TYPE_VOIDP, TYPE_VOIDP]
        members = [:type, :name, :label, :description, :info]
        super(address, types, members)
      end

      ##
      # @!attribute [r] type
      # @return [Integer] the type of this parameter.
      #   @see ParameterType

      def type
        self[:type]
      end

      ##
      # @!attribute [r] name
      # @return [String] the of the parameter to be displayed (ie "Cutoff
      #   frequency").

      def name
        (self + SIZEOF_INT).to_s(16).delete("\0").force_encoding('UTF-8')
      end

      ##
      # @!attribute [r] label
      # @return [String] a string to be put next to value to denote the unit
      #   type (ie "Hz").

      def label
        (self + SIZEOF_INT + 16).to_s(16).delete("\0")
      end

      ##
      # @!attribute [r] description
      # @return [String] the description of the parameter to be displayed as a
      #   help item / tooltip for this parameter.
      def description
        self[:description].to_s
      end

      ##
      # Struct containing information about the parameter. The type of info
      # will vary depending on the {#type} value.
      # * {ParameterType::FLOAT} => {FloatDescription}
      # * {ParameterType::INT} => {IntegerDescription}
      # * {ParameterType::BOOL} => {BoolDescription}
      # * {ParameterType::DATA} => {DataDescription}
      #
      # @return [FloatDescription, IntegerDescription, BoolDescription,
      #   DataDescription] the parameter type description.
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