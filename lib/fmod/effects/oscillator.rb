
module FMOD
  module Effects

    ##
    # This unit generates sine/square/saw/triangle or noise tones.
    #
    # @attr waveform [Integer] Waveform type.
    #   * *Minimum:* 0
    #   * *Maximum:* 5
    #   * *Default:* 0 (sine)
    #   @see SINE
    #   @see SQUARE
    #   @see SAW_UP
    #   @see SAW_DOWN
    #   @see TRIANGLE
    #   @see NOISE
    # @attr rate [Float] Frequency of the sine-wave in Hz.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 220.0
    class Oscillator < Dsp

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      SINE = 0

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      SQUARE = 1

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      SAW_UP = 2

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      SAW_DOWN = 3

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      TRIANGLE = 4

      ##
      # Strongly-typed waveform shape for {#waveform} parameter.
      NOISE = 5

      integer_param(0, :waveform, min: 0, max: 5)
      float_param(1, :rate, min: 1.0, max: 22000.0)
    end
  end
end