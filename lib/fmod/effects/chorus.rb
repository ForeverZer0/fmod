
module FMOD
  module Effects

    ##
    # This unit produces a chorus effect on the sound.
    #
    # Chorus is an effect where the sound is more "spacious" due to 1 to 3
    # versions of the sound being played along side the original signal but with
    # the pitch of each copy modulating on a sine wave.
    #
    # @attr mix [Float] Volume of original signal to pass to output.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 50.0
    # @attr rate [Float] Chorus modulation rate in Hz.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 20.0
    #   * *Default:* 0.8
    # @attr depth [Float] Chorus modulation depth.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 3.0
    class Chorus < Dsp
      float_param(0, :mix, min: 0.0, max: 100.0)
      float_param(1, :rate, min: 0.0, max: 20.0)
      float_param(2, :depth, min: 0.0, max: 100.0)
    end
  end
end