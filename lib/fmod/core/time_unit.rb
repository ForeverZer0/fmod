module FMOD
  module Core

    ##
    # Strongly-typed values for indicating various units of time.
    module TimeUnit

      ##
      # Milliseconds.
      MS = 0x00000001

      ##
      # PCM samples, related to milliseconds * sample rate / 1000.
      PCM = 0x00000002

      ##
      # Bytes, related to PCM samples * channels * data width (ie 16bit = 2 bytes).
      PCM_BYTES = 0x00000004

      ##
      # Raw file bytes of (compressed) sound data (does not include headers).
      RAW_BYTES = 0x00000008

      ##
      # Fractions of 1 PCM sample. Unsigned integer range 0 to 0xFFFFFFFF.
      #
      # Used for sub-sample granularity for DSP purposes.
      PCM_FRACTION = 0x00000010

      ##
      # MOD/S3M/XM/IT. Order in a sequenced module format.
      MOD_ORDER = 0x00000100

      ##
      # MOD/S3M/XM/IT. Current row in a sequenced module format.
      MOD_ROW = 0x00000200

      ##
      # MOD/S3M/XM/IT. Current pattern in a sequenced module format.
      MOD_PATTERN = 0x00000400
    end
  end
end