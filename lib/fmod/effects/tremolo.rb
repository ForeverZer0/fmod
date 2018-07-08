
module FMOD
  module Effects

    ##
    # This unit produces a tremolo / chopper effect on the sound.
    #
    # The tremolo effect varies the amplitude of a sound. Depending on the
    # settings, this unit can produce a tremolo, chopper or auto-pan effect.
    #
    # The shape of the LFO (low freq. oscillator) can morphed between sine,
    # triangle and sawtooth waves using the {#shape} and {#skew} parameters.
    #
    # {#duty} and {#square} are useful for a chopper-type effect where the first
    # controls the on-time duration and second controls the flatness of the
    # envelope.
    #
    # {#spread} varies the LFO phase between channels to get an auto-pan effect.
    # This works best with a sine shape LFO.
    #
    # The LFO can be synchronized using the {#phase} parameter which sets its
    # instantaneous phase.
    #
    # @attr frequency [Float] LFO frequency in Hz.
    #   * *Minimum:* 0.1
    #   * *Maximum:* 20.0
    #   * *Default:* 5.0
    # @attr depth [Float] Tremolo depth.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    # @attr shape [Float] LFO shape morph between triangle and sine.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    # @attr skew [Float] Time-skewing of LFO cycle.
    #   * *Minimum:* -1.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    # @attr duty [Float] LFO on-time. 0 to 1.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.5
    # @attr square [Float] Flatness of the LFO shape.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    # @attr phase [Float] Instantaneous LFO phase.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    # @attr spread [Float] Rotation / auto-pan effect.
    #   * *Minimum:* -1.0
    #   * *Maximum:* 1.0
    #   * *Default:* 0.0
    class Tremolo < Dsp
      float_param(0, :frequency, min: 0.1, max: 20.0)
      float_param(1, :depth, min: 0.0, max: 1.0)
      float_param(2, :shape, min: 0.0, max: 1.0)
      float_param(3, :skew, min: -1.0, max: 1.0)
      float_param(4, :duty, min: 0.0, max: 1.0)
      float_param(5, :square, min: 0.0, max: 1.0)
      float_param(6, :phase, min: 0.0, max: 1.0)
      float_param(7, :spread, min: -1.0, max: 1.0)
    end
  end
end