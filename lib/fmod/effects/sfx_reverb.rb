
module FMOD
  module Effects

    ##
    # This unit implements SFX reverb.
    #
    # This is a high quality I3DL2 based reverb.
    #
    # On top of the I3DL2 property set, "Dry Level" is also included to allow
    # the dry mix to be changed.
    #
    # @attr decay_time [Float] Reverberation decay time at low-frequencies in
    #   milliseconds.
    #   * *Minimum:* 100.0
    #   * *Maximum:* 20000.0
    #   * *Default:* 1500
    # @attr early_delay [Float] Delay time of first reflection in milliseconds.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 300.0
    #   * *Default:* 20.0
    # @attr late_delay [Float] Late reverberation delay time relative to first
    #   reflection in milliseconds.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 40.0
    # @attr hf_reference [Float] Reference frequency for high-frequency decay in
    #   Hz.
    #   * *Minimum:* 20.0
    #   * *Maximum:* 20000.0
    #   * *Default:* 5000.0
    # @attr hf_decay_ratio [Float] High-frequency decay time relative to decay
    #   time in percent.
    #   * *Minimum:* 10.0
    #   * *Maximum:* 100.0
    #   * *Default:* 50.0
    # @attr diffusion [Float] Reverberation diffusion (echo density) in percent.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 100.0
    # @attr density [Float] Reverberation density (modal density) in percent.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 100.0
    # @attr low_shelf_frequency [Float] Transition frequency of low-shelf filter
    #   in Hz.
    #   * *Minimum:* 20.0
    #   * *Maximum:* 1000.0
    #   * *Default:* 250.0
    # @attr low_shelf_gain [Float] Gain of low-shelf filter in dB.
    #   * *Minimum:* -36.0
    #   * *Maximum:* 12.0
    #   * *Default:* 0.0
    # @attr high_cut [Float] Cutoff frequency of low-pass filter in Hz.
    #   * *Minimum:* 20.0
    #   * *Maximum:* 20000.0
    #   * *Default:* 20000.0
    # @attr early_late_mix [Float] Blend ratio of late reverb to early
    #   reflections in percent.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 100.0
    #   * *Default:* 50.0
    # @attr wet_level [Float] Reverb signal level in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 20.0
    #   * *Default:* -6.0
    # @attr dry_level [Float] Dry signal level in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 20.0
    #   * *Default:* 0.0
    class SfxReverb < Dsp
      float_param(0, :decay_time, min: 100.0, max: 20000.0)
      float_param(0, :early_delay, min: 0.0, max: 300.0)
      float_param(0, :late_delay, min: 0.0, max: 100.0)
      float_param(0, :hf_reference, min: 20.0, max: 20000.0)
      float_param(0, :hf_decay_ratio, min: 10.0, max: 100.0)
      float_param(0, :diffusion, min: 0.0, max: 100.0)
      float_param(0, :density, min: 0.0, max: 100.0)
      float_param(0, :low_shelf_frequency, min: 20.0, max: 1000.0)
      float_param(0, :low_shelf_gain, min: -36.0, max: 12.0)
      float_param(0, :high_cut, min: 20.0, max: 20000.0)
      float_param(0, :early_late_mix, min: 0.0, max: 100.0)
      float_param(0, :wet_level, min: -80.0, max: 20.0)
      float_param(0, :dry_level, min: -80.0, max: 20.0)
    end
  end
end
