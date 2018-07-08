
module FMOD
  module Effects

    ##
    # @deprecated Deprecated and will be removed in a future release.
    #
    # This unit tracks the envelope of the input/side-chain signal.
    #
    # @attr attack [Float] Attack time (milliseconds).
    #   * *Minimum:* 0.1
    #   * *Maximum:* 1000.0
    #   * *Default:* 20.0
    # @attr release [Float] Release time (milliseconds).
    #   * *Minimum:* 10.0
    #   * *Maximum:* 5000.0
    #   * *Default:* 100.0
    # @attr_reader envelope [Float] Current value of the envelope.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    # @attr side_chain [Fiddle::Pointer|String] Whether to analyse the
    #   side-chain signal instead of the input signal.
    # @note This unit does not affect the incoming signal.
    class EnvelopeFollower < Dsp
      float_param(0, :attack, min: 0.1, max: 1000.0)
      float_param(1, :release, min: 10.0, max: 5000.0)
      float_param(2, :envelope, readonly: true)
      data_param(3, :side_chain)
    end
  end
end