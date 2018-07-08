
module FMOD
  module Effects

    ##
    # @deprecated Will be removed in a future FMOD version. See {MultibandEq}
    #   for alternatives.
    #
    # This unit filters sound using a resonant high-pass filter algorithm.
    #
    # @attr cutoff [Float] High-pass cutoff frequency in Hz.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 5000.0
    # @attr resonance [Float] High-pass resonance Q value.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 10.0
    #   * *Default:* 1.0
    class HighPass < Dsp
      float_param(0, :cutoff, min: 1.0, max: 22000.0)
      float_param(1, :resonance, min: 1.0, max: 10.0)
    end
  end
end