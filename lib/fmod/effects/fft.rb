module FMOD
  module Effects

    ##
    # This unit simply analyzes the signal and provides spectrum information.
    #
    # Set the attributes for the spectrum analysis with {#window_size} and
    # {#window_type}, and retrieve the results with {#spectrum} and
    # {#dominant_frequency}.
    #
    # @attr window_size [Integer] The size of the FFT window. Must be a power of
    #   2.
    #   * *Minimum:* 128
    #   * *Maximum:* 16384
    #   * *Default:* 2048
    #   * *Valid:* 128, 256, 512, 1024, 2048, 4096, 8192, 16384
    # @attr window_type [Integer] The shape of the FFT window.
    #   * *Minimum:* 0
    #   * *Maximum:* 5
    #   * *Default:* {WindowType::HAMMING}
    #   @see WindowType
    # @attr_reader spectrum [Pointer] Retrieves a pointer to the current
    #   spectrum values between 0 and 1 for each "FFT bin".
    # @attr_reader dominant_frequency [Float] The dominant frequencies for each
    #   channel.
    #
    # @see SpectrumData
    class FFT < Dsp
      integer_param(0, :window_size, min: 128, max: 16384)
      integer_param(1, :window_type, min: 0, max: 5)
      data_param(2, :spectrum, readonly: true)
      float_param(3, :dominant_frequency, readonly: true)

      # TODO Get SpectrumData structs

    end
  end
end