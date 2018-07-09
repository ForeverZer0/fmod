
module FMOD

  module Core

    WetDryMix = Struct.new(:pre_wet, :post_wet, :dry)

    LoopPoints = Struct.new(:start, :start_unit, :end, :end_unit)

    FadePoint = Struct.new(:clock, :volume)

    ##
    # Defines the sound projection cone including the volume when outside the
    # cone.
    #
    # @attr inside_angle [Float] Inside cone angle, in degrees. This is the
    #   angle within which the sound is at its normal volume.
    #
    #   Must not be greater than {#outside_angle}.
    #   * *Default:* 360.0
    # @attr outside_angle [Float] Outside cone angle, in degrees. This is the
    #   angle outside of which the sound is at its outside volume.
    #
    #   Must not be less than {#inside_angle}.
    #   * *Default:* 360.0
    # @attr outside_volume [Float] Cone outside volume.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    ConeSettings = Struct.new(:inside_angle, :outside_angle, :outside_volume)
  end
end









