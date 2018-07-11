module FMOD
  module Core

    ##
    # Strongly-typed index values to denote special types of node within a DSP
    # chain.
    module DspIndex

      ##
      # Head of the DSP chain. Equivalent of index 0.
      HEAD = -1

      ##
      # Built in fader DSP.
      FADER = -2

      ##
      # Tail of the DSP chain. Equivalent of the number of DSPs minus 1.
      TAIL = -3
    end
  end
end