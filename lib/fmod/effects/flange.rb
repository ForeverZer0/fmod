
module FMOD
  module Effects

    ##
    # This unit produces a flange effect on the sound.
    #
    # Flange is an effect where the signal is played twice at the same time, and
    # one copy slides back and forth creating a whooshing or flanging effect.
    #
    # As there are 2 copies of the same signal, by default each signal is given
    # 50% mix, so that the total is not louder than the original unaffected
    # signal.
    #
    # Flange depth is a percentage of a 10ms shift from the original signal.
    # Anything above 10ms is not considered flange because to the ear it begins
    # to "echo" so 10ms is the highest value possible.
    #
    # @attr mix [Float] Percentage of wet signal in mix.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 50.0
    # @attr depth [Float] Flange depth (percentage of 40ms delay).
    #   * *Minimum:* 0.01
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    # @attr rate [Float] Flange speed in Hz.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 20.0
    #   * *Default:* 0.1
    class Flange < Dsp
      float_param(0, :mix, min: 0.0, max: 100.0)
      float_param(1, :depth, min: 0.01, max: 1.0)
      float_param(2, :rate, min: 0.0, max: 20.0)
    end
  end
end