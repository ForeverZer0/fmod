module FMOD
  module Core
    module InitFlags
      NORMAL = 0x00000000
      STREAM_FROM_UPDATE = 0x00000001
      MIX_FROM_UPDATE = 0x00000002
      RIGHT_HANDED_3D = 0x00000004
      CHANNEL_LOW_PASS = 0x00000100
      CHANNEL_DISTANCE_FILTER = 0x00000200
      PROFILE_ENABLE = 0x00010000
      VOL0_BECOMES_VIRTUAL = 0x00020000
      GEOMETRY_USE_CLOSEST = 0x00040000
      PREFER_DOLBY_DOWN_MIX = 0x00080000
      THREAD_UNSAFE = 0x00100000
      PROFILE_METER_ALL = 0x00200000
      DISABLE_SRS_HIGH_PASS_FILTER = 0x00400000
    end
  end
end