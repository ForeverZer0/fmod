module FMOD
  module Core

    ##
    # Filter types to be used with the MultiBandEQ DSP.
    module FilterType

      ##
      # Disabled filter, no processing.
      DISABLED = 0

      ##
      # Resonant low-pass filter, attenuates frequencies (12dB per octave) above
      # a given point (with specified resonance) while allowing the rest to
      # pass.
      LOW_PASS_12DB = 1

      ##
      # Resonant low-pass filter, attenuates frequencies (24dB per octave) above
      # a given point (with specified  resonance) while allowing the rest to
      # pass.
      LOW_PASS_24DB = 2

      ##
      # Resonant low-pass filter, attenuates frequencies (48dB per octave) above
      # a given point (with specified resonance) while allowing the rest to
      # pass.
      LOW_PASS_48DB = 3

      ##
      # Resonant low-pass filter, attenuates frequencies (12dB per octave) below
      # a given point (with specified resonance) while allowing the rest to
      # pass.
      HIGH_PASS_12DB = 4

      ##
      # Resonant low-pass filter, attenuates frequencies (24dB per octave) below
      # a given point (with specified resonance) while allowing the rest to
      # pass.
      HIGH_PASS_24DB = 5

      ##
      # Resonant low-pass filter, attenuates frequencies (48dB per octave) below
      # a given point (with specified resonance) while allowing the rest to
      # pass.
      HIGH_PASS_48DB = 6

      ##
      # Low-shelf filter, boosts or attenuates frequencies (with specified gain)
      # below a given point while allowing the rest to pass.
      LOW_SHELF = 7

      ##
      # High-shelf filter, boosts or attenuates frequencies (with specified
      # gain) above a given point while allowing the rest to pass.
      HIGH_SHELF = 8

      ##
      # Peaking filter, boosts or attenuates frequencies (with specified gain)
      # at a given point (with specified bandwidth) while allowing the rest to
      # pass.
      PEAKING = 9

      ##
      # Band-pass filter, allows frequencies at a given point (with specified
      # bandwidth) to pass while attenuating frequencies outside this range.
      BANDPASS = 10

      ##
      # Notch or band-reject filter, attenuates frequencies at a given point
      # (with specified bandwidth) while allowing frequencies outside this
      # range to pass.
      NOTCH = 11
      
      ##
      # All-pass filter, allows all frequencies to pass, but changes the phase
      # response at a given point (with specified sharpness).
      ALL_PASS = 12
    end
  end
end