
module FMOD
  module Effects

    ##
    # This unit pans and scales the volume of a unit.
    #
    # @attr gain [Float] Signal gain in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    class Fader < Dsp
      float_param(0, :gain, min: -80.0, max: 10.0)
    end
  end
end