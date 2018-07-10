module FMOD
  module Core

    ##
    # These definitions describe the type of song being played.
    module SoundType

      ##
      # 3rd party / unknown plugin format.
      UNKNOWN = 0
      ##
      # AIFF.
      AIFF = 1
      ##
      # Microsoft Advanced Systems Format (ie WMA/ASF/WMV).
      ASF = 2
      ##
      # Sound font / downloadable sound bank.
      DLS= 3
      ##
      # FLAC loss-less codec.
      FLAC = 4
      ##
      # FMOD Sample Bank.
      FSB = 5
      ##
      # Impulse Tracker.
      IT = 6
      ##
      # MIDI.
      MIDI = 7
      ##
      # Pro-tracker / Fast-tracker MOD.
      MOD = 8
      ##
      # MP2/MP3 MPEG.
      MPEG = 9
      ##
      # Ogg vorbis.
      OGG_VORBIS = 10
      ##
      # Information only from ASX/PLS/M3U/WAX play-lists.
      PLAY_LIST = 11
      ##
      # Raw PCM data.
      RAW = 12
      ##
      # ScreamTracker 3.
      S3M = 13
      ##
      # User created sound.
      USER = 14
      ##
      # Microsoft WAV.
      WAV = 15
      ##
      # FastTracker 2 XM.
      XM = 16
      ##
      # Xbox360 XMA.
      XMA = 17
      ##
      # iPhone hardware decoder, supports AAC, ALAC and MP3.
      AUDIO_QUEUE = 18
      ##
      # PS4 / PSVita ATRAC 9 format.
      AT9 = 19
      ##
      # Vorbis.
      VORBIS = 20
      ##
      # Windows Store Application built in system codecs.
      MEDIA_FOUNDATION = 21
      ##
      # Android MediaCodec.
      MEDIA_CODEC = 22
      ##
      # FMOD Adaptive Differential Pulse Code Modulation.
      FAD_PCM = 23
    end
  end
end