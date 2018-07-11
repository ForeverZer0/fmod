module FMOD
  module Core

    ##
    # These definitions can be used for creating FMOD defined special effects or
    # DSP units.
    module DspType

      ##
      # This unit was created via a non FMOD plugin so has an unknown purpose.
      UNKNOWN = 0

      ##
      # This unit does nothing but take inputs and mix them together then feed
      # the result to the sound card unit.
      MIXER = 1

      ##
      # This unit generates sine/square/saw/triangle or noise tones.
      OSCILLATOR = 2

      ##
      # @deprecated Deprecated and will be removed in a future release
      #   (see MULTIBAND_EQ for alternatives).
      # This unit filters sound using a high quality, resonant low-pass filter
      # algorithm but consumes more CPU time.
      LOW_PASS = 3

      deprecate_constant :LOW_PASS

      ##
      # This unit filters sound using a resonant low-pass filter algorithm that
      # is used in Impulse Tracker, but with limited cutoff range (0 to 8060hz).
      IT_LOW_PASS = 4

      ##
      # @deprecated Deprecated and will be removed in a future release
      #   (see MULTIBAND_EQ for alternatives).
      # This unit filters sound using a resonant high-pass filter algorithm.
      HIGH_PASS = 5

      deprecate_constant :HIGH_PASS

      ##
      # This unit produces an echo on the sound and fades out at the desired
      # rate.
      ECHO = 6

      ##
      # This unit pans and scales the volume of a unit.
      FADER = 7

      ##
      # This unit produces a flange effect on the sound.
      FLANGE = 8

      ##
      # This unit distorts the sound.
      DISTORTION = 9

      ##
      # This unit normalizes or amplifies the sound to a certain level.
      NORMALIZE = 10

      ##
      # This unit limits the sound to a certain level.
      LIMITER = 11

      ##
      # @deprecated Deprecated and will be removed in a future release
      #   (see MULTIBAND_EQ for alternatives).
      # This unit attenuates or amplifies a selected frequency range.
      PARAM_EQ = 12

      ##
      # This unit bends the pitch of a sound without changing the speed of
      # playback.
      PITCH_SHIFT = 13

      ##
      # This unit produces a chorus effect on the sound.
      CHORUS = 14

      ##
      # This unit allows the use of Steinberg VST plugins.
      VST_PLUGIN = 15

      ##
      # This unit allows the use of Nullsoft Winamp plugins.
      WINAMP_PLUGIN = 16

      ##
      # This unit produces an echo on the sound and fades out at the desired
      # rate as is used in Impulse Tracker.
      IT_ECHO = 17

      ##
      # This unit implements dynamic compression (linked/unlinked multichannel,
      # wide-band)
      COMPRESSOR = 18

      ##
      # This unit implements SFX reverb.
      SFX_REVERB = 19

      ##
      # @deprecated Deprecated and will be removed in a future release
      #   (see MULTIBAND_EQ for alternatives).
      # This unit filters sound using a simple low-pass with no resonance, but
      # has flexible cutoff and is fast.
      LOW_PASS_SIMPLE = 20

      deprecate_constant :LOW_PASS_SIMPLE

      ##
      # This unit produces different delays on individual channels of the sound.
      DELAY = 21

      ##
      # This unit produces a tremolo / chopper effect on the sound.
      TREMOLO = 22

      ##
      # @deprecated Do not use, no longer supported.
      # Unsupported / Deprecated.
      LADSPA_PLUGIN = 23

      deprecate_constant :LADSPA_PLUGIN

      ##
      # This unit sends a copy of the signal to a return DSP anywhere in the DSP
      # tree.
      SEND = 24

      ##
      # This unit receives signals from a number of send DSPs.
      RETURN = 25

      ##
      # @deprecated Deprecated and will be removed in a future release
      #   (see MULTIBAND_EQ for alternatives).
      # This unit filters sound using a simple high-pass with no resonance, but
      # has flexible cutoff and is fast.
      HIGH_PASS_SIMPLE = 26

      deprecate_constant :HIGH_PASS_SIMPLE

      ##
      # This unit pans the signal, possibly up-mixing or down-mixing as well.
      PAN = 27

      ##
      # This unit is a three-band equalizer.
      THREE_EQ = 28

      ##
      # This unit simply analyzes the signal and provides spectrum information
      # back through its parameter.
      FFT = 29

      ##
      # This unit analyzes the loudness and true peak of the signal.
      LOUDNESS_METER = 30

      ##
      # This unit tracks the envelope of the input/sidechain signal. Deprecated
      # and will be removed in a future release.
      ENVELOPE_FOLLOWER = 31

      ##
      # This unit implements convolution reverb.
      CONVOLUTION_REVERB = 32

      ##
      # This unit provides per signal channel gain, and output channel mapping
      # to allow 1 multichannel signal made up of many groups of signals to map
      # to a single output signal.
      CHANNEL_MIX = 33

      ##
      # This unit "sends" and "receives" from a selection of up to 32 different
      # slots. It is like a send/return but it uses global slots rather than
      # returns as the destination. It also has other features. Multiple
      # transceivers can receive from a single channel, or multiple transceivers
      # can send to a single channel, or a combination of both.
      TRANSCEIVER = 34

      ##
      # This unit sends the signal to a 3d object encoder like Dolby Atmos.
      OBJECT_PAN = 35

      ##
      # This unit is a flexible five band parametric equalizer.
      MULTIBAND_EQ = 36
    end
  end
end