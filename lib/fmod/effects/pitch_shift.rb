module FMOD
  module Effects

    ##
    # This unit bends the pitch of a sound without changing the speed of playback.
    #
    # This pitch shifting unit can be used to change the pitch of a sound
    # without speeding it up or slowing it down.
    #
    # It can also be used for time stretching or scaling, for example if the
    # pitch was doubled, and the frequency of the sound was halved, the pitch of
    # the sound would sound correct but it would be twice as slow.
    #
    # @note This filter is very computationally expensive! Similar to a vocoder,
    #   it requires several overlapping FFT and IFFT's to produce smooth output,
    #   and can require around 440mhz for 1 stereo 48khz signal using the
    #   default settings.
    #
    #   Reducing the signal to mono will half the CPU usage.
    #
    #   Reducing this will lower audio quality, but what settings to use are
    #   largely dependant on the sound being played. A noisy polyphonic signal
    #   will need higher FFT size compared to a speaking voice for example.
    #
    # @attr pitch [Float] Pitch value.
    #   * *Minimum:* 0.5 (one octave lower)
    #   * *Maximum:* 2.0 (one octave higher)
    #   * *Default:* 1.0 (normal)
    # @attr window_size [Float] FFT window size. Increase this to reduce
    #   "smearing". This effect is a warbling sound similar to when an MP3 is
    #   encoded at very low bit-rates.
    #   * *Minimum:* 256
    #   * *Maximum:* 4096
    #   * *Default:* 1024
    #   * *Valid:* 256, 512, 1024, 2048, 4096
    # @attr max_channels [Float] Maximum channels supported. 0 = same
    #   as FMOD's default output polyphony, 1 = mono, 2 = stereo etc.
    #   * *Minimum:* 0
    #   * *Maximum:* 16
    #   * *Default:* 0 (strongly recommended to leave at 0!)
    class PitchShift < Dsp
      float_param(0, :pitch, min: 0.5, max: 2.0)
      float_param(1, :window_size, min: 256, max: 4096)
      float_param(3, :max_channels, min: 0, max: 16)
    end
  end
end