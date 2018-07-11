module FMOD
  module Core

    ##
    # Strongly-typed supported output types.
    module OutputType

      ##
      # Picks the best output mode for the platform. This is the default.
      AUTO_DETECT = 0

      ##
      # All - 3rd party plugin, unknown.
      UNKNOWN = 1

      ##
      # All - Perform all mixing but discard the final output.
      NO_SOUND = 2

      ##
      # All - Writes output to a .wav file.
      WAV_WRITER = 3

      ##
      # All - Non-realtime version of {NO_SOUND}. User can drive mixer with
      # System.update at whatever rate they want.
      NO_SOUND_NRT = 4

      ##
      # All - Non-realtime version of {WAV_WRITER}. User can drive mixer with
      # System.update at whatever rate they want.
      WAV_WRITER_NRT = 5

      ##
      # Windows only - Direct Sound. (Default on Windows XP and below)
      DSOUND = 6

      ##
      # Windows only - Windows Multimedia.
      WINMM = 7

      ##
      # Win/WinStore/XboxOne - Windows Audio Session API. (Default on Windows
      # Vista and above, Xbox One and Windows Store Applications)
      WASAPI = 8

      ##
      # Windows only - Low latency ASIO 2.0.
      ASIO = 9

      ##
      # Linux - Pulse Audio. (Default on Linux if available)
      PULSE_AUDIO = 10

      ##
      # Linux - Advanced Linux Sound Architecture. (Default on Linux if
      # PulseAudio isn't available)
      ALSA = 11

      ##
      # Mac/iOS - Core Audio. (Default on Mac and iOS)
      CORE_AUDIO = 12

      ##
      # Xbox 360 - XAudio. (Default on Xbox 360)
      X_AUDIO = 13

      ##
      # PS3 - Audio Out. (Default on PS3)
      PS3 = 14

      ##
      # Android - Java Audio Track. (Default on Android 2.2 and below)
      AUDIO_TRACK = 15

      ##
      # Android - OpenSL ES. (Default on Android 2.3 and above)
      OPEN_SL = 16

      ##
      # Wii U - AX. (Default on Wii U)
      WII_U = 17

      ##
      # PS4/PSVita - Audio Out. (Default on PS4 and PS Vita)
      AUDIO_OUT, = 18

      ##
      # PS4 - Audio3D.
      AUDIO3D = 19

      ##
      # Windows - Dolby Atmos (WASAPI).
      ATMOS = 20

      ##
      # Web Browser - JavaScript webaudio output. (Default on JavaScript)
      WEB_AUDIO = 21

      ##
      # NX - NX nn::audio. (Default on NX)
      NN_AUDIO = 22

      ##
      # Win10 / XboxOne - Windows Sonic.
      WIN_SONIC = 23
    end
  end
end