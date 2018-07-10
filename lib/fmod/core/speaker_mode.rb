
module FMOD
  module Core

    ##
    # These are speaker types defined for use with the software format commands.
    module SpeakerMode

      ##
      # Default speaker mode for the chosen output mode which will resolve after
      # System.create.
      DEFAULT = 0

      ##
      # Assume there is no special mapping from a given channel to a speaker,
      # channels map 1:1 in order.
      RAW = 1

      ##
      # 1 speaker setup (monaural).
      MONO = 2

      ##
      # 2 speaker setup (stereo) front left, front right.
      STEREO = 3

      ##
      # 4 speaker setup (4.0) front left, front right, surround left, surround
      # right.
      QUAD = 4

      ##
      # 5 speaker setup (5.0) front left, front right, center, surround left,
      # surround right.
      SURROUND = 5

      ##
      # 6 speaker setup (5.1) front left, front right, center, low frequency,
      # surround left, surround right.
      FIVE_POINT_ONE = 6

      ##
      # 8 speaker setup (7.1) front left, front right, center, low frequency,
      # surround left, surround right, back left, back right.
      SEVEN_POINT_ONE = 7

      ##
      # 12 speaker setup (7.1.4) front left, front right, center, low frequency,
      # surround left, surround right, back left, back right, top front left,
      # top front right, top back left, top back right.
      SEVEN_POINT_FOUR = 9
    end
  end
end