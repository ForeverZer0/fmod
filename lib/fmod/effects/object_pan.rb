module FMOD
  module Effects

    ##
    # This unit sends the signal to a 3d object encoder like Dolby Atmos.
    # Supports a subset of the {DspType::PAN} parameters.
    #
    # 3D Object panners are meant for hardware 3d object systems like Dolby
    # Atmos or Sony Morpheus. These object panners take input in, and send it to
    # the 7.1 bed, but do not send the signal further down the DSP chain (the
    # output of the dsp is silence).
    #
    # @attr position [Pointer|String] 3D Position
    # @attr rolloff [Integer] 3D Rolloff
    #   * *Minimum:* 0
    #   * *Maximum:* 4
    #   * *Default:* 0 (linear-squared)
    #   @see Pan::ROLLOFF_LINEAR_SQUARED
    #   @see Pan::ROLLOFF_LINEAR
    #   @see Pan::ROLLOFF_INVERSE
    #   @see Pan::ROLLOFF_INVERSE_TAPERED
    #   @see Pan::ROLLOFF_CUSTOM
    # @attr min_distance [Float] 3D Min Distance
    #   * *Minimum:* 0.0
    #   * *Default:* 1.0
    # @attr max_distance [Float] 3D Max Distance
    #   * *Minimum:* 0.0
    #   * *Default:* 1.0
    # @attr extent_mode [Integer] 3D Extent Mode
    #   * *Minimum:* 0 (auto)
    #   * *Maximum:* 2 (off)
    #   * *Default:* 0 (auto)
    #   @see Pan::EXTENT_AUTO
    #   @see Pan::EXTENT_USER
    #   @see Pan::EXTENT_OFF
    # @attr sound_size [Float] 3D Sound Size
    #   * *Minimum:* 0.0
    #   * *Default:* 0.0
    # @attr min_extent [Float] 3D Min Extent (degrees)
    #   * *Minimum:* 0.0
    #   * *Maximum:* 360.0
    #   * *Default:* 0.0
    # @attr overall_gain [Pointer|String] Overall gain. For information only,
    #   not set by user. Allows FMOD to know the DSP is scaling the signal for
    #   virtualization purposes.
    # @attr output_gain [Float] Output gain level, linear scale. For the user to
    #   scale the output of the object panner's signal.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    class ObjectPan < Dsp
      data_param(0, :position)
      integer_param(1, :rolloff, min: 0, max: 4)
      float_param(2, :min_distance, min: 0.0)
      float_param(3, :max_distance, min: 0.0)
      integer_param(4, :extent_mode, min: 0, max: 2)
      float_param(5, :sound_size, min: 0.0)
      float_param(6, :min_extent, min: 0.0, max: 360.0)
      data_param(7, :overall_gain)
      float_param(8, :output_gain, min: 0.0, max: 20.0)
    end
  end
end