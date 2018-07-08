
module FMOD
  module Effects

    ##
    # This unit provides per signal channel gain, and output channel mapping to
    # allow 1 multichannel signal made up of many groups of signals to map to a
    # single output signal.
    #
    # @attr output_grouping [Integer] Determines the output mapping.
    #
    #   This value will set the output speaker format for the DSP, and also map
    #   the incoming channels to the outgoing channels in a round-robin fashion.
    #   Use this for example play a 32 channel input signal as if it were a
    #   repeating group of output signals.
    #
    #   {ALL_MONO} = all incoming channels are mixed to a mono output.
    #
    #   {ALL_STEREO} = all incoming channels are mixed to a stereo output, ie
    #   even incoming channels 0,2,4,6,etc are mixed to left, and odd incoming
    #   channels 1,3,5,7,etc are mixed to right.
    #
    #   {ALL_5POINT1} = all incoming channels are mixed to a 5.1 output. If
    #   there are less than 6 coming in, it will just fill the first n channels
    #   in the 6 output channels. If there are more, then it will repeat the
    #   input pattern to the output like it did with the stereo case, ie 12
    #   incoming channels are mapped as 0-5 mixed to the 5.1 output and 6 to 11
    #   mapped to the 5.1 output.
    #
    #   {ALL_LFE} = all incoming channels are mixed to a 5.1 output but via the
    #   LFE channel only.
    #   * *Default:* {DEFAULT}
    #   @see DEFAULT
    #   @see ALL_MONO
    #   @see ALL_STEREO
    #   @see ALL_QUAD
    #   @see ALL_5POINT1
    #   @see ALL_7POINT1
    #   @see ALL_LFE
    class ChannelMix < Dsp

      ##
      # Output channel count = input channel count.
      # @see SpeakerIndex
      DEFAULT = 0

      ##
      # Output channel count = 1. Mapping: Mono, Mono, Mono, Mono, Mono,
      # Mono, ... (each channel all the way up to {FMOD::MAX_CHANNEL_WIDTH}
      # channels are treated as if they were mono)
      ALL_MONO = 1

      ##
      # Output channel count = 2. Mapping: Left, Right, Left, Right, Left,
      # Right, ... (each pair of channels is treated as stereo all the way up to
      # {FMOD::MAX_CHANNEL_WIDTH} channels)
      ALL_STEREO = 2

      ##
      # Output channel count = 4. Mapping: Repeating pattern of Front Left,
      # Front Right, Surround Left, Surround Right
      ALL_QUAD = 3

      ##
      # Output channel count = 6. Mapping: Repeating pattern of Front Left,
      # Front Right, Center, LFE, Surround Left, Surround Right.
      ALL_5POINT1 = 4

      ##
      # Output channel count = 8. Mapping: Repeating pattern of Front Left,
      # Front Right, Center, LFE, Surround Left, Surround Right, Back Left, Back
      # Right.
      ALL_7POINT1 = 5

      ##
      # Output channel count = 6. Mapping: Repeating pattern of LFE in a 5.1
      # output signal.
      ALL_LFE = 6

      integer_param(0, :output_grouping, min: 0, max: 6)

      ##
      # Retrieves the gain for the specified channel.
      # @param channel [Integer] The channel index, clamped between 0 and 31.
      # @return [Float] The gain.
      def [](channel)
        get_float(channel.clamp(0, 31) + 1)
      end

      ##
      # Sets the gain, in dB for the specified channel.
      # @param channel [Integer] The channel index, clamped between 0 and 31.
      # @param gain [Float] The gain, in dB, clamped between -80.0 and 10.0.
      # @return [Float] The gain.
      def []=(channel, gain)
        set_float(channel.clamp(0, 31) + 1, gain.clamp(-80.0, 10.0))
        gain
      end
    end
  end
end