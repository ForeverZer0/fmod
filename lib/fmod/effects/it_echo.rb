
module FMOD
  module Effects

    ##
    # This unit produces an echo on the sound and fades out at the desired rate
    # as is used in Impulse Tracker.
    #
    # This is effectively a software based echo filter that emulates the DirectX
    # DMO echo effect. Impulse tracker files can support this, and FMOD will
    # produce the effect on ANY platform, not just those that support DirectX
    # effects!
    #
    # @note Every time the delay is changed, the plugin re-allocates the echo
    #   buffer. This means the echo will disappear at that time while it refills
    #   its new buffer.
    #
    #   Larger echo delays result in larger amounts of memory allocated.
    #
    #   As this is a stereo filter made mainly for IT playback, it is targeted
    #   for stereo signals. With mono signals only the {#left_delay} is used.
    #
    #   For multichannel signals (>2) there will be no echo on those channels.
    # @attr wet_dry_mix [Float] Ratio of wet (processed) signal to dry
    #   (unprocessed) signal.
    #   * *Minimum:* 0.0 (all dry)
    #   * *Maximum:* 100.0 (all wet)
    #   * *Default:* 50.0
    # @attr feedback [Float] Percentage of output fed back into input.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 50.0
    # @attr left_delay [Float] Delay for left channel, in milliseconds.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 2000.0
    #   * *Default:* 500.0
    # @attr right_delay [Float] Delay for right channel, in milliseconds.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 2000.0
    #   * *Default:* 500.0
    # @attr pan_delay [Float] Value that specifies whether to swap left and
    #   right delays with each successive echo. Ranges from 0.0 (equivalent to
    #   +false+) to 1.0 (equivalent to +true+), meaning no swap.
    #   @note Currently not supported within the FMOD API.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    class ITEcho < Dsp
      float_param(0, :wet_dry_mix, min: 0.0, max: 100.0)
      float_param(1, :feedback, min: 0.0, max: 100.0)
      float_param(2, :left_delay, min: 1.0, max: 2000.0)
      float_param(3, :right_delay, min: 1.0, max: 2000.0)
      float_param(4, :pan_delay , min: 0.0, max: 1.0)
    end
  end
end