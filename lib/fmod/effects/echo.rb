
module FMOD
  module Effects

    ##
    # This unit produces an echo on the sound and fades out at the desired rate.
    #
    # @note Every time the delay is changed, the plugin re-allocates the echo
    #   buffer. This means the echo will disappear at that time while it refills
    #   its new buffer.
    #
    #   Larger echo delays result in larger amounts of memory allocated.
    #
    # @attr delay [Float] Echo delay in ms.
    #   * *Minimum:* 10.0
    #   * *Maximum:* 5000.0
    #   * *Default:* 500.0
    # @attr feedback [Float] Echo decay per delay.
    #   * *Minimum:* 0.0 (total decay)
    #   * *Maximum:* 100.0 (no decay)
    #   * *Default:* 50.0
    # @attr dry_level [Float] Original sound volume in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr wet_level [Float] Volume of echo signal to pass to output in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    class Echo < Dsp
      float_param(0, :delay, min: 10.0, max: 5000.0)
      float_param(1, :feedback, min: 0.0, max: 100.0)
      float_param(2, :dry_level, min: -80.0, max: 10.0)
      float_param(3, :wet_level, min: -80.0, max: 10.0)
    end
  end
end