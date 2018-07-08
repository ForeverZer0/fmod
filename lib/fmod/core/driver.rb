module FMOD
  module Core

    ##
    # Identification information about a sound device.
    class Driver

      private_class_method :new

      ##
      # @return [Integer] the enumerated driver ID.
      attr_reader :id

      ##
      # @return [String] the name of the device encoded in a UTF-8 string.
      attr_reader :name

      ##
      # @return [Guid] the GUID that uniquely identifies the device.
      attr_reader :guid

      ##
      # @return [Integer] the sample rate this device operates at.
      attr_reader :rate

      ##
      # @return [Integer] the speaker setup this device is currently using.
      # @see SpeakerMode
      attr_reader :speaker_mode

      ##
      # @return [Integer] the number of channels in the current speaker setup.
      attr_reader :channels

      ##
      # @return [Integer] flags that provide additional information about the
      #   driver.
      attr_reader :state

      ##
      # @param args [Array] Array of binary data.
      # @api private
      def initialize(args)
        @id = args.shift
        # noinspection RubyResolve
        @name = args.shift.delete("\0").force_encoding(Encoding::UTF_8)
        args.shift
        @guid = args.shift
        @rate, @speaker_mode, @channels, @state = args.join.unpack('l*')
      end

      ##
      # @return [Boolean] +true+ if this a record driver, otherwise +false+.
      def record_driver?
        !@state.nil?
      end
    end
  end
end