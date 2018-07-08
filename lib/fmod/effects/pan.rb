module FMOD
  module Effects

    ##
    # This unit pans the signal, possibly up-mixing or down-mixing as well.
    #
    # @attr panning_mode [Integer] Panner mode.
    #   * *0:* Mono down-mix
    #   * *1:* Stereo panning
    #   * *2:* Surround panning
    # @attr stereo_position [Float] 2D Stereo pan position.
    #   * *Minimum:* -100.0
    #   * *Maximum:* 100.0
    #   * *Default:* 0.0
    # @attr surround_direction [Float] 2D Surround pan direction. Direction from
    #   center point of panning circle, in degrees.
    #   * *Minimum:* -180.0 (rear-speakers center point)
    #   * *Maximum:* 180.0 (rear-speakers center point)
    #   * *Default:* 0.0 (front-center)
    # @attr surround_extent [Float] 2D Surround pan extent. Distance from center
    #   point of panning circle, in degrees.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 360.0
    #   * *Default:* 360.0
    # @attr surround_rotation [Float] 2D Surround pan rotation.
    #   * *Minimum:* -180.0 (degrees)
    #   * *Maximum:* 180.0 (degrees)
    #   * *Default:* 0.0
    # @attr surround_lfe_level [Float] 2D Surround pan LFE level. 2D LFE level
    #   in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 20.0
    #   * *Default:* 0.0
    # @attr stereo_surround [Integer] Stereo-to-surround mode.
    #   * *0:* Distributed
    #   * *1:* Discrete (default)
    # @attr surround_stereo_separation [Float] Stereo-To-Surround Stereo (only
    #   for {#stereo_surround}) "discrete" mode). Separation/width of L/R parts
    #   of stereo sound, in degrees.
    #   * *Minimum:* -180.0
    #   * *Maximum:* 180.0
    #   * *Default:* 60.0
    # @attr surround_stereo_axis [Float] Stereo-To-Surround Stereo (only for
    #   {#stereo_surround}) "discrete" mode). Axis/rotation of L/R parts of
    #   stereo sound, in degrees.
    #   * *Minimum:* -180.0
    #   * *Maximum:* 180.0
    #   * *Default:* 0.0
    # @attr surround_speakers [Integer] Speakers Enabled. Bit-mask for each
    #   speaker from 0 to 32 to be considered by panner. Use to disable speakers
    #   from being panned to.
    #   * *Minimum:* 0
    #   * *Maximum:* 0xFFF
    #   * *Default:* 0xFFF (all on)
    # @attr position [Pointer|String] 3D Position.
    # @attr rolloff [Integer] 3D Rolloff.
    #   * *Minimum:* 0
    #   * *Maximum:* 4
    #   * *Default:* 0 (linear-squared)
    #   @see ROLLOFF_LINEAR_SQUARED
    #   @see ROLLOFF_LINEAR
    #   @see ROLLOFF_INVERSE
    #   @see ROLLOFF_INVERSE_TAPERED
    #   @see ROLLOFF_CUSTOM
    # @attr min_distance [Float] 3D Min Distance.
    #   * *Minimum:* 0.0
    #   * *Default:* 1.0
    # @attr max_distance [Float] 3D Max Distance.
    #   * *Minimum:* 0.0
    #   * *Default:* 20.0
    # @attr extent_mode [Integer] 3D Extent Mode.
    #   * *Minimum:* 0 (auto)
    #   * *Maximum:* 2 (off)
    #   * *Default:* 0 (auto)
    #   @see EXTENT_AUTO
    #   @see EXTENT_USER
    #   @see EXTENT_OFF
    # @attr sound_size [Float] 3D Sound Size.
    #   * *Minimum:* 0.0
    #   * *Default:* 0.0
    # @attr min_extent [Float] 3D Min Extent.
    #   * *Minimum:* 0.0 (degrees)
    #   * *Maximum:* 360.0 (degrees)
    #   * *Default:* 0.0
    # @attr pan_blend [Float] 3D Pan Blend.
    #   * *Minimum:* 0.0 (fully 2D)
    #   * *Maximum:* 1.0 (fully 3D)
    #   * *Default:* 0.0
    # @attr lfe_upmix_enabled [Integer] LFE Up-mix Enabled. Determines whether
    #   non-LFE source channels should mix to the LFE or leave it alone.
    #   * *Minimum:* 0 (off)
    #   * *Maximum:* 1 (on)
    #   * *Default:* 0 (off)
    # @attr overall_gain [Pointer] Overall gain. For information only,
    #   not set by user. Data to provide to FMOD, to allow FMOD to know the DSP
    #   is scaling the signal for virtualization purposes.
    # @attr speaker_mode [Integer] Surround speaker mode. Target speaker mode
    #   for surround panning.
    #   * *Minimum:* 0
    #   * *Maximum:* 9
    #   * *Default:* {SpeakerMode::DEFAULT}
    #   @see SpeakerMode
    # @attr height_blend [Float] 2D Height blend. When the input or
    #   {#speaker_mode} has height speakers, control the blend between ground
    #   and height.
    #   * *Minimum:* -1.0 (push top speakers to ground)
    #   * *Maximum:* 1.0 (push ground speakers to top)
    #   * *Default:* 0.0 (preserve top / ground separation)
    class Pan < Dsp
      integer_param(0, :panning_mode, min: 0, max: 2)
      float_param(1, :stereo_position, min: -100.0, max: 100.0)
      float_param(2, :surround_direction, min: -180.0, max: 180.0)
      float_param(3, :surround_extent, min: 0.0, max: 360.0)
      float_param(4, :surround_rotation, min: -180.0, max: 180.0)
      float_param(5, :surround_lfe_level, min: -80.0, max: 20.0)
      integer_param(6, :stereo_surround, min: 0, max: 1)
      float_param(7, :surround_stereo_separation, min: -180.0, max: 180.0)
      float_param(8, :surround_stereo_axis, min: -180.0, max: 180.0)
      integer_param(9, :surround_speakers, min: 0, max: 4095)
      data_param(10, :position)
      integer_param(11, :rolloff, min: 0, max: 4)
      float_param(12, :min_distance, min: 0.0)
      float_param(13, :max_distance, min: 0.0)
      integer_param(14, :extent_mode, min: 0, max: 2)
      float_param(15, :sound_size, min: 0.0)
      float_param(16, :min_extent, min: 0.0, max: 360.0)
      float_param(17, :pan_blend, min: 0.0, max: 1.0)
      integer_param(18, :lfe_upmix_enabled, min: 0, max: 1)
      data_param(19, :overall_gain)
      integer_param(20, :speaker_mode, min: 0, max: 8)
      float_param(21, :height_blend, min: -1.0, max: 1.0)

      ##
      # Strongly-typed value used with {#extent_mode}.
      EXTENT_AUTO = 0

      ##
      # Strongly-typed value used with {#extent_mode}.
      EXTENT_USER = 1

      ##
      # Strongly-typed value used with {#extent_mode}.
      EXTENT_OFF = 2

      ##
      # Strongly typed 3D rolloff value used with {#rolloff}.
      ROLLOFF_LINEAR_SQUARED = 0

      ##
      # Strongly typed 3D rolloff value used with {#rolloff}.
      ROLLOFF_LINEAR = 1

      ##
      # Strongly typed 3D rolloff value used with {#rolloff}.
      ROLLOFF_INVERSE = 2

      ##
      # Strongly typed 3D rolloff value used with {#rolloff}.
      ROLLOFF_INVERSE_TAPERED = 3

      ##
      # Strongly typed 3D rolloff value used with {#rolloff}.
      ROLLOFF_CUSTOM = 4
    end
  end
end