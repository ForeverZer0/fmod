module FMOD
  module Core

    ##
    # Initialization flags. Use them with System.create in the flags parameter
    # to change various behavior.
    #
    # Use System advanced settings to adjust settings for some of the features
    # that are enabled by these flags.
    module InitFlags

      ##
      # Initialize normally.
      NORMAL = 0x00000000

      ##
      # No stream thread is created internally. Streams are driven from
      # System.update. Mainly used with non-realtime outputs.
      STREAM_FROM_UPDATE = 0x00000001

      ##
      # No mixer thread is created internally. Mixing is driven from
      # System.update.
      MIX_FROM_UPDATE = 0x00000002

      ##
      # 3D calculations will be performed in right-handed coordinates.
      RIGHT_HANDED_3D = 0x00000004

      ##
      # Enables usage of Channel low-pass gain, Channel occlusion, or automatic
      # usage by the Geometry API. All voices will add a software low-pass
      # filter effect into the DSP chain which is idle unless one of the
      # previous functions/features are used.
      CHANNEL_LOW_PASS = 0x00000100

      ##
      # All FMOD 3D based voices will add a software low-pass and high-pass
      # filter effect into the DSP chain which will act as a distance-automated
      # bandpass filter. Use System advanced settings to adjust the center
      # frequency.
      CHANNEL_DISTANCE_FILTER = 0x00000200

      ##
      # Enable TCP/IP based host which allows FMOD Designer or FMOD Profiler to
      # connect to it, and view memory, CPU and the DSP network graph in
      # real-time.
      PROFILE_ENABLE = 0x00010000

      ##
      # Any sounds that are 0 volume will go virtual and not be processed except
      # for having their positions updated virtually. Use System advanced
      # settings to adjust what volume besides zero to switch to virtual at.
      VOL0_BECOMES_VIRTUAL = 0x00020000

      ##
      # With the geometry engine, only process the closest polygon rather than
      # accumulating all polygons the sound to listener line intersects.
      GEOMETRY_USE_CLOSEST = 0x00040000

      ##
      # When using a 5.1 speaker mode with a stereo output device, use the Dolby
      # Pro Logic II down-mix algorithm instead of the SRS Circle Surround
      # algorithm.
      PREFER_DOLBY_DOWN_MIX = 0x00080000

      ##
      # Disables thread safety for API calls. Only use this if FMOD low level is
      # being called from a single thread, and if Studio API is not being used!
      THREAD_UNSAFE = 0x00100000

      ##
      # Slower, but adds level metering for every single DSP unit in the graph.
      PROFILE_METER_ALL = 0x00200000

      ##
      # Using a 5.1 speaker mode with a stereo output device will enable the SRS
      # Circle Surround down-mixer. By default the SRS down-mixer applies a high
      # pass filter with a cutoff frequency of 80Hz. Use this flag to disable
      # the high pass filter, or use {PREFER_DOLBY_DOWN_MIX} to use the Dolby
      # Pro Logic II down-mix algorithm instead.
      DISABLE_SRS_HIGH_PASS_FILTER = 0x00400000
    end
  end
end