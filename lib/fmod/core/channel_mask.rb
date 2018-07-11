module FMOD
  module Core

    ##
    # These are bit-fields to describe for a certain number of channels in a
    # signal, which channels are being represented.
    #
    # For example, a signal could be 1 channel, but contain the LFE channel
    # only.
    module ChannelMask

      ##
      # Front-left
      FRONT_LEFT = 0x00000001

      ##
      # Front-right
      FRONT_RIGHT = 0x00000002

      ##
      # Front-center
      FRONT_CENTER = 0x00000004

      ##
      # Low-frequency or sub-woofer
      LOW_FREQUENCY = 0x00000008

      ##
      # Surround-left
      SURROUND_LEFT = 0x00000010

      ##
      # Surround-right
      SURROUND_RIGHT = 0x00000020

      ##
      # Back-left
      BACK_LEFT = 0x00000040

      ##
      # Back-right
      BACK_RIGHT = 0x00000080

      ##
      # Back-center
      BACK_CENTER = 0x00000100

      ##
      # Mono, single speaker
      MONO = FRONT_LEFT

      ##
      # Stereo
      STEREO = FRONT_LEFT | FRONT_RIGHT

      ##
      # Left-Right-Center
      LRC = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER

      ##
      # Quads
      QUAD = FRONT_LEFT | FRONT_RIGHT | SURROUND_LEFT | SURROUND_RIGHT

      ##
      # Surround
      SURROUND = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER | SURROUND_LEFT | SURROUND_RIGHT

      ##
      # 5.1
      FIVE_POINT_ONE = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER | LOW_FREQUENCY | SURROUND_LEFT | SURROUND_RIGHT

      ##
      # 5.1 with Rears
      FIVE_POINT_ONE_REARS = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER | LOW_FREQUENCY | BACK_LEFT | BACK_RIGHT

      ##
      # 7.0 Surround
      SEVEN_POINT_ZERO = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER | SURROUND_LEFT | SURROUND_RIGHT | BACK_LEFT | BACK_RIGHT

      ##
      # 7.1 Surround
      SEVEN_POINT_ONE = FRONT_LEFT | FRONT_RIGHT | FRONT_CENTER | LOW_FREQUENCY | SURROUND_LEFT | SURROUND_RIGHT | BACK_LEFT | BACK_RIGHT
    end
  end
end