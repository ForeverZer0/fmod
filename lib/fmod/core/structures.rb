
module FMOD

  module Core

    ##
    # Describes the loop points for the channel.
    # @attr start [Integer] The  loop start point, this point in time is played
    #   so it is inclusive.
    # @attr start_unit [Integer] Time format used for the loop start point. See
    #   {TimeUnit}.
    # @attr end [Integer] The loop end point, this point in time is played so it
    #   is inclusive.
    # @attr end_unit [Integer] Time format used for the loop end point. See
    #   {TimeUnit}.
    LoopPoints = Struct.new(:start, :start_unit, :end, :end_unit)

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









