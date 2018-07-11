
module FMOD

  ##
  # Represents a logical grouping of {Sound} objects that can be manipulated as
  # one.
  class SoundGroup < Handle

    include Fiddle
    include Enumerable

    ##
    # @!attribute max_audible
    # Limits the number of concurrent playbacks of sounds in a sound group to
    # the specified value.
    #
    # After this, if the sounds in the sound group are playing this many times,
    # any attempts to play more of the sounds in the sound group will by default
    # fail an exception.
    #
    # Use {#behavior} to change the way the sound playback behaves when too many
    # sounds are playing. Muting, failing and stealing behaviors can be
    # specified.
    #
    # @return [Integer] the number of playbacks to be audible at once. -1 (the
    #   default) denotes unlimited.
    integer_reader(:max_audible, :SoundGroup_GetMaxAudible)
    integer_writer(:max_audible=, :SoundGroup_SetMaxAudible, min: -1)

    ##
    # @!attribute behavior
    # Determines the way the sound playback behaves when too many sounds are
    # playing in a sound group. Muting, failing and stealing behaviors can be
    # specified.
    #
    # @return [Integer] the current behavior.
    # @see SoundGroupBehavior
    integer_reader(:behavior, :SoundGroup_GetMaxAudibleBehavior)
    integer_writer(:behavior=, :SoundGroup_SetMaxAudibleBehavior)

    ##
    # @!attribute volume
    # The volume for a sound group, affecting all channels playing the sounds in
    # this sound group.
    #
    # 0.0 is silent, 1.0 is full volume, though negative values and
    # amplification are supported.
    #
    # @return [Float] the sound group volume.
    float_reader(:volume, :SoundGroup_GetVolume)
    float_writer(:volume=, :SoundGroup_SetVolume)

    ##
    # @!attribute fade_speed
    # @return [Float] the time in seconds to fade with when {#behavior} is set
    #   to {SoundGroupBehavior::MUTE}. By default there is no fade.
    float_reader(:fade_speed, :SoundGroup_GetMuteFadeSpeed)
    float_writer(:fade_speed=, :SoundGroup_SetMuteFadeSpeed)

    ##
    # @!attribute [r] playing_count
    # @return [Integer] e number of currently playing channels for the group.
    integer_reader(:playing_count, :SoundGroup_GetNumPlaying)

    ##
    # @!attribute [r] count
    # @return [Integer] the current number of sounds in this sound group.
    integer_reader(:count, :SoundGroup_GetNumSounds)

    alias_method :size, :count

    ##
    # @!attribute [r] name
    # @return [String] the name of the sound group.
    def name
      buffer = "\0" * 512
      FMOD.invoke(:SoundGroup_GetName, self, buffer, 512)
      buffer.delete("\0")
    end

    ##
    # Enumerates the sounds contained within the sound group.
    #
    # @overload each
    #   When called with block, yields each {Sound within the object before
    #   returning self.
    #   @yield [sound] Yields a sound to the block.
    #   @yieldparam sound [Sound] The current enumerated polygon.
    #   @return [self]
    # @overload each
    #   When no block specified, returns an Enumerator for the {SoundGroup}.
    #   @return [Enumerator]
    def each
      return to_enum(:each) unless block_given?
      (0...count).each { |i| yield self[i] }
      self
    end

    ##
    # Retrieves a sound from within a sound group.
    #
    # @param index [Integer] Index of the sound that is to be retrieved.
    #
    # @return [Sound, nil] the desired Sound object, or +nil+ if index was out
    #   of range.
    def [](index)
      return nil unless FMOD.valid_range?(0, 0, count - 1, false)
      FMOD.invoke(:SoundGroup_GetSound, self, index, sound = int_ptr)
      Sound.new(sound)
    end

    alias_method :sound, :[]

    ##
    # @!attribute [r] parent
    # @return [System] the parent {System} object that was used to create this
    #   object.
    def parent
      FMOD.invoke(:SoundGroup_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    ##
    # Stops all sounds within this sound group.
    # @return [void]
    def stop
      FMOD.invoke(:SoundGroup_Stop, self)
    end
  end
end