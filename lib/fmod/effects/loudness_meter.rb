module FMOD
  module Effects

    ##
    # This unit analyzes the loudness and true peak of the signal.
    # @note This DSP is not intended for public use.
    # @attr state [Integer] Integration state
    #   * *Minimum:* -3
    #   * *Maximum:* 1
    # @attr weights [Pointer] Channel weightings for loudness.
    # @attr loudness [Pointer] Loudness info and maximum true peak level.
    # @api private
    class LoudnessMeter < Dsp
      integer_param(0, :state, min: -3, max: 1)
      data_param(1, :weights)
      data_param(2, :loudness)
    end
  end
end