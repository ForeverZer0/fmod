module FMOD
  module Effects

    ##
    # This unit implements convolution reverb.
    #
    # @attr_writer ir [Pointer|String] Array of signed 16-bit (short) PCM data
    #   to be used as reverb IR. First member of the array should be a 16-bit
    #   value (short) which specifies the number of channels. Array looks like
    #   [index 0 = channel_count][index 1+ = raw 16-bit PCM data].
    #
    #   Data is copied internally so source can be freed.
    # @attr wet [Float] Volume of echo signal to pass to output in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr dry [Float] Original sound volume in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr linked [Boolean] Indicates if channels are mixed together before
    #   processing through the reverb.
    #   * *Default:* +true+
    class ConvolutionReverb < Dsp
      data_param(0, :ir, write_only: true)
      float_param(1, :wet, min: -80.0, max: 10.0)
      float_param(2, :dry, min: -80.0, max: 10.0)
      bool_param(3, :linked)
    end
  end
end