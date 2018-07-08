
module FMOD
  module Effects

    ##
    # This unit produces different delays on individual channels of the sound.
    #
    # @note Every time MaxDelay is changed, the plugin re-allocates the delay
    #   buffer. This means the delay will disappear at that time while it
    #   refills its new buffer.
    #
    #   A larger {#max_delay} results in larger amounts of memory allocated.
    #
    #   Channel delays above {#max_delay} will be clipped to MaxDelay and the
    #   delay buffer will not be re-sized.
    #
    # @attr max_delay [Float] Maximum delay in ms.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 10000.0
    #   * *Default:* 10.0
    class Delay < Dsp

      ##
      # Retrieves the delay, in ms, for the specified channel.
      # @param channel [Integer] The channel index to retrieve (0 to 15).
      # @return [Float]
      def [](channel)
        get_float(channel.clamp(0, 15))
      end

      ##
      # Sets the delay, in ms, for the specified channel.
      # @param channel [Integer] The channel index to set (0 to 15).
      # @param delay [Float] The delay value, clamped between 0.0 and 10000.0.
      # @return [Float] The delay.
      def []=(channel, delay)
        set_float(channel.clamp(0, 15), delay.clamp(0.0, 10000.0))
        delay
      end

      integer_param(16, :max_delay, min: 0.0, max: 10000.0)
    end
  end
end