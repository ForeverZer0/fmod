
module FMOD
  class Channel < ChannelControl

    ##
    # @!attribute frequency
    # This value can also be negative to play the sound backwards (negative
    # frequencies allowed with non-stream sounds only).
    #
    # When a sound is played, it plays at the default frequency of the sound
    # which can be set by {Sound.default_frequency}.
    #
    # For most file formats, the default frequency is determined by the audio
    # format.
    #
    # @return [Float] the channel frequency or playback rate, in Hz.
    float_reader(:frequency, :Channel_GetFrequency)
    float_writer(:frequency=, :Channel_SetFrequency)

    ##
    # @!attribute [r] index
    # @return [Integer] the internal channel index for a channel.
    integer_reader(:index, :Channel_GetIndex)

    ##
    # @!attribute priority
    # The channel priority.
    #
    # When more channels than available are played the virtual channel system
    # will choose existing channels to steal. Lower priority sounds will always
    # be stolen before higher priority sounds. For channels of equal priority,
    # that with the quietest {ChannelControl.audibility} value will be stolen.
    # * *Minimum:* 0
    # * *Maximum:* 256
    # * *Default:* 128
    # @return [Integer] the current priority.
    integer_reader(:priority, :Channel_GetPriority)
    integer_writer(:priority=, :Channel_SetPriority, 0, 256)

    ##
    # @!attribute loop_count
    # Sets a sound, by default, to loop a specified number of times before
    # stopping if its mode is set to {Mode::LOOP_NORMAL} or {Mode::LOOP_BIDI}.
    # @return [Integer] the number of times to loop a sound before stopping.
    integer_reader(:loop_count, :Channel_GetLoopCount)
    integer_writer(:loop_count=, :Channel_SetLoopCount, -1)

    ##
    # @!attribute [r] current_sound
    # @return [Sound, nil] the currently playing sound for this channel, or
    #   +nil+ if no sound is playing.
    def current_sound
      FMOD.invoke(:Channel_GetCurrentSound, self, sound = int_ptr)
      sound.unpack1('J').zero? ? nil : Sound.new(sound)
    end

    ##
    # @!method virtual?
    # Retrieves whether the channel is virtual (emulated) or not due to the
    # virtual channel management system
    # @return [Boolean] the current virtual state.
    #   * *true:* Inaudible and currently being emulated at no CPU cost
    #   * *false:* Real voice that should be audible.
    bool_reader(:virtual?, :Channel_IsVirtual)

    ##
    # Returns the current playback position.
    # @param unit [Integer] Time unit to retrieve into the position in.
    #   @see TimeUnit
    # @return [Integer] the current playback position.
    def position(unit = TimeUnit::MS)
      buffer = "\0" * SIZEOF_INT
      FMOD.invoke(:Channel_SetPosition, self, buffer, unit)
      buffer.unpack1('L')
    end

    ##
    # Sets the playback position for the currently playing sound to the
    # specified offset.
    # @param position [Integer] Position of the channel to set in specified
    #   units.
    # @param unit [Integer] Time unit to set the channel position by.
    #   @see TimeUnit
    # @return [self]
    def seek(position, unit = TimeUnit::MS)
      position = 0 if position < 0
      FMOD.invoke(:Channel_SetPosition, self, position, unit)
      self
    end

    ##
    # @!attribute group
    # @return [ChannelGroup] the currently assigned channel group for this
    #   {Channel}.

    def group
      FMOD.invoke(:Channel_GetChannelGroup, self, group = int_ptr)
      ChannelGroup.new(group)
    end

    def group=(channel_group)
      FMOD.type?(channel_group, ChannelGroup)
      FMOD.invoke(:Channel_SetChannelGroup, self, channel_group)
    end

    ##
    # Retrieves the loop points for a sound.
    # @param start_unit [Integer] The time format used for the returned loop
    #   start point.
    #   @see TimeUnit
    # @param end_unit [Integer] The time format used for the returned loop end
    #   point.
    #   @see TimeUnit
    # @return [Array(Integer, Integer)] the loop points in an array where the
    #   first element is the start loop point, and second element is the end
    #   loop point in the requested time units.
    def loop_points(start_unit = TimeUnit::MS, end_unit = TimeUnit::MS)
      loop_start, loop_end = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:Channel_GetLoopPoints, self, loop_start,
        start_unit, loop_end, end_unit)
      [loop_start.unpack1('L'), loop_end.unpack1('L')]
    end

    ##
    # Sets the loop points within a sound
    #
    # If a sound was 44100 samples long and you wanted to loop the whole sound,
    # _loop_start_ would be 0, and _loop_end_ would be 44099, not 44100. You
    # wouldn't use milliseconds in this case because they are not sample
    # accurate.
    #
    # If loop end is smaller or equal to loop start, it will result in an error.
    #
    # If loop start or loop end is larger than the length of the sound, it will
    # result in an error
    #
    # @param loop_start [Integer] The loop start point. This point in time is
    #   played, so it is inclusive.
    # @param loop_end [Integer] The loop end point. This point in time is
    #   played, so it is inclusive
    # @param start_unit [Integer] The time format used for the loop start point.
    #   @see TimeUnit
    # @param end_unit [Integer] The time format used for the loop end point.
    #   @see TimeUnit
    def set_loop(loop_start, loop_end, start_unit = TimeUnit::MS, end_unit = TimeUnit::MS)
      FMOD.invoke(:Channel_SetLoopPoints, self, loop_start,
        start_unit, loop_end, end_unit)
      self
    end
  end
end