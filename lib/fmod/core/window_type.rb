module FMOD
  module Core

    ##
    # List of windowing methods for the {Effects::FFT} unit. Used in spectrum
    # analysis to reduce leakage / transient signals interfering with the
    # analysis.
    #
    # This is a problem with analysis of continuous signals that only have a
    # small portion of the signal sample (the FFT window size).
    #
    # Windowing the signal with a curve or triangle tapers the sides of the FFT
    # window to help alleviate this problem.
    #
    # Cyclic signals such as a sine wave that repeat their cycle in a multiple
    # of the window size do not need windowing. I.e. If the sine wave repeats
    # every 1024, 512, 256 etc samples and the FMOD FFT window is 1024, then the
    # signal would not need windowing.
    #
    # Not windowing is the same as :rectangle, which is the default.
    #
    # If the cycle of the signal (ie the sine wave) is not a multiple of the
    # window size, it will cause frequency abnormalities, so a different
    # windowing method is needed.
    module WindowType

      ##
      # Rectangle.
      #   w[n] = 1.0
      RECT = 0

      ##
      # Triangle.
      #   w[n] = TRI(2n/N)
      TRIANGLE = 1

      ##
      # Hamming.
      #   w[n] = 0.54 - (0.46 * COS(n/N) )
      HAMMING = 2

      ##
      # Hanning.
      #   w[n] = 0.5 * (1.0 - COS(n/N) )
      HANNING = 3

      ##
      # Blackman.
      #   w[n] = 0.42 - (0.5 * COS(n/N) ) + (0.08 * COS(2.0 * n/N) )
      BLACKMAN = 4

      ##
      # Blackman-Harris.
      #   w[n] = 0.35875 - (0.48829 * COS(1.0 * n/N)) + (0.14128 * COS(2.0 * n/N)) - (0.01168 * COS(3.0 * n/N))
      BLACKMAN_HARRIS = 5
    end
  end
end