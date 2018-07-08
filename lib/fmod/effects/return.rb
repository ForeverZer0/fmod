
module FMOD
  module Effects

    ##
    # This unit receives signals from a number of send DSPs.
    #
    # @attr_reader id [Integer] ID of this Return DSP.
    #   * *Default:* -1
    # @attr speaker_mode [Integer] Input speaker mode of this return.
    #   * *Default:* {SpeakerMode::DEFAULT}
    #   @see SpeakerMode
    class Return < Dsp
      integer_param(0, :id, readonly: true)
      integer_param(1, :speaker_mode, min: 0, max: 9)
    end
  end
end