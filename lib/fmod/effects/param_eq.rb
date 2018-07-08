
module FMOD
  module Effects

    ##
    # @deprecated Will be removed in a future FMOD version. See {MultibandEq}
    #   for alternatives.
    #
    # This unit attenuates or amplifies a selected frequency range.
    #
    # Parametric EQ is a single band peaking EQ filter that attenuates or
    # amplifies a selected frequency and its neighbouring frequencies.
    #
    # When a frequency has its gain set to 1.0, the sound will be unaffected and
    # represents the original signal exactly.
    #
    # @attr center [Float] Frequency center.
    #   * *Minimum:* 20.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 8000.0
    # @attr bandwidth [Float] Octave range around the center frequency to
    #   filter.
    #   * *Minimum:* 0.2
    #   * *Maximum:* 5.0
    #   * *Default:* 1.0
    # @attr gain [Float] Frequency gain in dB.
    #   * *Minimum:* -30.0
    #   * *Maximum:* 30.0
    #   * *Default:* 0.0
    class ParamEq < Dsp
      float_param(0, :center, min: 20.0, max: 22000.0)
      float_param(1, :bandwidth, min: 0.2, max: 5.0)
      float_param(2, :gain, min: -30.0, max: 30.0)
    end
  end
end