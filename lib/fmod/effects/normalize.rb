
module FMOD
  module Effects

    ##
    # This unit normalizes or amplifies the sound to a certain level.
    #
    # Normalize amplifies the sound based on the maximum peaks within the
    # signal.
    #
    # For example if the maximum peaks in the signal were 50% of the bandwidth,
    # it would scale the whole sound by 2.
    #
    # The lower threshold value makes the normalizer ignores peaks below a
    # certain point, to avoid over-amplification if a loud signal suddenly came
    # in, and also to avoid amplifying to maximum things like background hiss.
    #
    # Because FMOD is a realtime audio processor, it doesn't have the luxury of
    # knowing the peak for the whole sound (ie it can't see into the future), so
    # it has to process data as it comes in.
    #
    #
    # To avoid very sudden changes in volume level based on small samples of new
    # data, fmod fades towards the desired amplification which makes for smooth
    # gain control. The fade-time parameter can control this.
    #
    # @attr fade_time [Float] Time to ramp the silence to full in ms.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 20000.0
    #   * *Default:* 5000.0
    # @attr threshold [Float] Lower volume range threshold to ignore. Raise
    #   higher to stop amplification of very quiet signals.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.1
    # @attr max_amp [Float] Maximum amplification allowed. Higher values allow
    #   more boost.
    #   * *Minimum:* 1.0 (no amplification)
    #   * *Maximum:* 100000.0
    #   * *Default:* 20.0
    class Normalize < Dsp
      float_param(0, :fade_time, min: 0.0, max: 20000.0)
      float_param(1, :threshold, min: 0.0, max: 1.0)
      float_param(2, :max_amp, min: 1.0, max: 100000.0)
    end
  end
end