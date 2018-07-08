
module FMOD
  module Effects

    ##
    # This unit sends a copy of the signal to a return DSP anywhere in the DSP
    # tree.
    #
    # @attr id [Integer] ID of the Return DSP this send is connected to (integer
    #   values only).
    #   * *Default:* -1 (indicates no connected {Return} DSP)
    # @attr level [Float] Send level.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    class Send < Dsp
      integer_param(0, :id, min: -1)
      integer_param(1, :level, min: 0.0, max: 1.0)
    end
  end
end