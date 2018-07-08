module FMOD
  module Core
    ##
    # These definitions describe the native format of the hardware or software
    # buffer that will be used.
    module SoundFormat
      ##
      # Uninitialized / unknown.
      NONE = 0
      ##
      # 8-bit integer PCM data.
      PCM_8 = 1
      ##
      # 16-bit integer PCM data.
      PCM_16 = 2
      ##
      # 24-bit integer PCM data.
      PCM_24 = 3
      ##
      # 32-bit integer PCM data.
      PCM_32 = 4
      ##
      # 32-bit floating point PCM data.
      PCM_FLOAT = 5
      ##
      # Sound data is in its native compressed format.
      BIT_STREAM = 6
    end
  end
end