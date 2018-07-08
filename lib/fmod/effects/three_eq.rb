module FMOD
  module Effects

    ##
    # This unit is a three-band equalizer.
    #
    # @attr low_gain [Float] Low frequency gain in dB. .
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr mid_gain [Float] Mid frequency gain in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr high_gain [Float] High frequency gain in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr low_crossover [Float] Low-to-mid crossover frequency in Hz.
    #   * *Minimum:* 10.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 4000.0
    # @attr high_crossover [Float] Mid-to-high crossover frequency in Hz.
    #   * *Minimum:* 10.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 4000.0
    # @attr crossover_slope [Integer] Crossover slope.
    #   * *0:* 12dB/Octave
    #   * *1:* 24dB/Octave
    #   * *2:* 48dB/Octave
    #   * *Default:* 1 (24dB/Octave)
    class ThreeEq < Dsp
      float_param(0, :low_gain, min: -80.0, max: 10.0)
      float_param(1, :mid_gain, min: -80.0, max: 10.0)
      float_param(2, :high_gain, min: -80.0, max: 10.0)
      float_param(3, :low_crossover, min: 10.0, max: 22000.0)
      float_param(4, :high_crossover, min: 10.0, max: 22000.0)
      integer_param(5, :crossover_slope, min: 0, max: 2)
    end
  end
end