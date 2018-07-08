
module FMOD
  module Effects

    ##
    # This unit "sends" and "receives" from a selection of up to 32 different
    # slots. It is like a send/return but it uses global slots rather than
    # returns as the destination. It also has other features. Multiple
    # transceivers can receive from a single channel, or multiple transceivers
    # can send to a single channel, or a combination of both.
    #
    # The transceiver only transmits and receives to a global array of 32
    # channels. The transceiver can be set to receiver mode (like a {Return})
    # and can receive the signal at a variable {#gain}. The transceiver can also
    # be set to transmit to a channel (like a {Send}) and can transmit the
    # signal with a variable {#gain}.
    #
    # The {#speaker_mode} is only applicable to the transmission format, not the
    # receive format. This means this parameter is ignored in "receive mode".
    # This allows receivers to receive at the speaker mode of the user's choice.
    # Receiving from a mono channel, is cheaper than receiving from a surround
    # channel for example. The 3 speaker modes {SpeakerMode::MONO},
    # {SpeakerMode::STEREO}, {SpeakerMode::SURROUND} are stored as separate
    # buffers in memory for a transmitter channel. To save memory, use 1 common
    # speaker mode for a transmitter.
    #
    # The transceiver is double buffered to avoid de-syncing of transmitters and
    # receivers. This means there will be a 1 block delay on a receiver,
    # compared to the data sent from a transmitter.
    #
    # Multiple transmitters sending to the same channel will be mixed together.
    #
    # @attr transmit [Boolean] The behavior of the unit.
    #   * *false:* Transceiver is a "receiver" (like a {Return}) and accepts
    #     data from a channel.
    #   * *true:* Transceiver is a "transmitter" (like a {Send}).
    #   * *Default:* +false+
    # @attr gain [Float] Gain to receive or transmit at in dB.
    #   * *Minimum:* -80.0
    #   * *Maximum:* 10.0
    #   * *Default:* 0.0
    # @attr channel [Integer] Integer to select current global slot, shared by
    #   all Transceivers, that can be transmitted to or received from.
    #   * *Minimum:* 0
    #   * *Maximum:* 31
    #   * *Default:* 0
    # @attr speaker_mode [Integer] Speaker mode (transmitter mode only).
    #   * *Default:* {SpeakerMode::DEFAULT}
    #   @see SpeakerMode
    class Transceiver < Dsp
      bool_param(0, :transmit)
      float_param(1, :gain, min: -80.0, max: 10.0)
      integer_param(2, :channel, min: 0, max: 31)
      integer_param(3, :speaker_mode, min: 0, max: 9)
    end
  end
end