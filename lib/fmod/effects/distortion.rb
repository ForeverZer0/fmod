
module FMOD
  module Effects

    ##
    # This unit distorts the sound.
    #
    # @attr distortion [Float] Distortion value.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.5
    class Distortion < Dsp
      float_param(0, :distortion, min: 0.0, max: 1.0)
    end
  end
end