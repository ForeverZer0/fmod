
module FMOD
  module Effects

    ##
    # This unit limits the sound to a certain level.
    #
    # @attr release_time [Float] Time to ramp the silence to full in ms.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 1000.0
    #   * *Default:* 10.0
    # @attr ceiling [Float] Maximum level of the output signal in dB.
    #   * *Minimum:* -12.0
    #   * *Maximum:* 0.0
    #   * *Default:* 0.0
    # @attr max_gain [Float] Maximum amplification allowed in dB. Higher values
    #   allow more boost.
    #   * *Minimum:* 0.0 (no amplification)
    #   * *Maximum:* 12.0
    #   * *Default:* 0.0
    # @attr mode [Float] Channel processing mode. 0 or 1.
    #   * *Minimum:* 0.0 (independent, limiter per channel)
    #   * *Maximum:* 1.0 (linked)
    #   * *Default:* 0.0
    class Limiter < Dsp
      float_param(0, :release_time, min: 1.0, max: 1000.0)
      float_param(1, :ceiling, min: -12.0, max: 0.0)
      float_param(2, :max_gain, min: 0.0, max: 12.0)
      float_param(3, :mode, min: 0.0, max: 1.0)
    end
  end
end