module FMOD
  module Core

    ##
    # Strongly-typed values for indicating the data types used in music tags.
    module TagDataType

      ##
      # Raw binary data.
      BINARY = 0

      ##
      # A 32-bit integer
      INT = 1

      ##
      # A 32-bit floating point value
      FLOAT = 2

      ##
      # A string with no specified encoding.
      STRING = 3

      ##
      # A UTF-16 encoded string.
      STRING_UTF16 = 4

      ##
      # A UTF-16 Big-Endian string.
      STRING_UTF16BE = 5

      ##
      # A UTF-8 encoded string.
      STRING_UTF8 = 6

      ##
      # @deprecated Do not use.
      # A CDTOC tag.
      CDTOC = 7

      deprecate_constant :CDTOC
    end
  end
end