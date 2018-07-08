
module FMOD
  module Effects

    ##
    # @deprecated Will be removed in a future FMOD version. See {MultibandEq}
    #   for alternatives.
    #
    # This unit filters sound using a simple low-pass with no resonance, but has
    # flexible cutoff and is fast.
    #
    # This is a very simple low pass filter, based on two single-pole RC
    # time-constant modules.
    #
    # The emphasis is on speed rather than accuracy, so this should not be used
    # for task requiring critical filtering.
    #
    # @attr cutoff [Float] Low-pass cutoff frequency in Hz.
    #   * *Minimum:* 10.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 1000.0
    class LowPassSimple < Dsp
      float_param(0, :cutoff, min: 10.0, max: 22000.0)
    end
  end
end