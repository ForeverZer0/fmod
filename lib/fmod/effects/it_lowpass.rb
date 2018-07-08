

module FMOD
  module Effects

    ##
    # This unit filters sound using a resonant low-pass filter algorithm that is
    # used in Impulse Tracker, but with limited cutoff range (0 to 8060hz).
    #
    # This is different to the default {LowPass} filter in that it uses a
    # different quality algorithm and is the filter used to produce the correct
    # sounding playback in .IT files.
    #
    # FMOD Studio's .IT playback uses this filter.
    #
    # @note This filter actually has a limited cutoff frequency below the
    #   specified maximum, due to its limited design, so for a more open range
    #   filter use {LowPass} or if you don't mind not having resonance,
    #   {LowPassSimple}.
    #
    #   The effective maximum cutoff is about 8060hz.
    #
    # @attr cutoff [Float] Low-pass cutoff frequency in Hz.
    #   * *Minimum:* 1.0
    #   * *Maximum:* 22000.0
    #   * *Default:* 5000.0
    # @attr resonance [Float] Low-pass resonance Q value.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 127.0
    #   * *Default:* 1.0
    class ITLowPass < Dsp
      float_param(0, :cutoff, min: 1.0, max: 22000.0)
      float_param(1, :resonance, min: 0.0, max: 127.0)
    end
  end
end