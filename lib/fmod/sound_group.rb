
module FMOD
  class SoundGroup < Handle

    include Fiddle
    include Enumerable

    integer_reader(:max_audible, :SoundGroup_GetMaxAudible)
    integer_writer(:max_audible=, :SoundGroup_SetMaxAudible)

    integer_reader(:behavior, :SoundGroup_GetMaxAudibleBehavior)
    integer_writer(:behavior=, :SoundGroup_SetMaxAudibleBehavior)

    float_reader(:volume, :SoundGroup_GetVolume)
    float_writer(:volume=, :SoundGroup_SetVolume)

    float_reader(:fade_speed, :SoundGroup_GetMuteFadeSpeed)
    float_writer(:fade_speed=, :SoundGroup_SetMuteFadeSpeed)

    integer_reader(:count, :SoundGroup_GetNumSounds)
    integer_reader(:playing_count, :SoundGroup_GetNumPlaying)

    alias_method :size, :count

    def name
      buffer = "\0" * 512
      FMOD.invoke(:SoundGroup_GetName, self, buffer, 512)
      buffer.delete("\0")
    end

    def each
      return to_enum(:each) unless block_given?
      (0...count).each { |i| yield self[i] }
      self
    end

    def [](index)
      FMOD.valid_range?(0, 0, count - 1)
      FMOD.invoke(:SoundGroup_GetSound, self, index, sound = int_ptr)
      Sound.new(sound)
    end

    alias_method :sound, :[]

    def parent
      FMOD.invoke(:SoundGroup_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    def stop
      FMOD.invoke(:SoundGroup_Stop, self)
    end
  end
end