module FMOD
  module Core

    ##
    # List of tag types that could be stored within a sound. These include id3
    # tags, metadata from net-streams and vorbis/asf data.
    # @since 0.9.2
    module TagType

      ##
      # Unknown
      UNKNOWN = 0

      ##
      # ID3V1
      ID3V1 = 1

      ##
      # ID3V2
      ID3V2 = 2

      ##
      # Vorbis Comment
      VORBIS_COMMENT = 3

      ##
      # ShoutCast
      SHOUT_CAST = 4

      ##
      # IceCast
      ICE_CAST = 5

      ##
      # ASF
      ASF = 6

      ##
      # MIDI
      MIDI = 7

      ##
      # Play list
      PLAYLIST = 8

      ##
      # FMOD
      FMOD = 9

      ##
      # User
      USER = 10
    end
  end
end