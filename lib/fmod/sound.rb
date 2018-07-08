
module FMOD
  class Sound < Handle

    ##
    # Contains format information about the sound.
    # @attr type [Integer] The type of sound.
    #   @see SoundType
    # @attr format [Integer] The format of the sound.
    #   @see SoundFormat
    # @attr channels [Integer] The number of channels for the sound.
    # @attr bits [Integer] The number of bits per sample for the sound.
    Format = Struct.new(:type, :format, :channels, :bits)

    ##
    # Contains the state a sound is in after {Mode::NON_BLOCKING} has been used
    # to open it, or the state of the streaming buffer.
    #
    # When a sound is opened with {Mode::NON_BLOCKING}, it is opened and
    # prepared in the background, or asynchronously.
    # This allows the main application to execute without stalling on audio
    # loads.
    # This function will describe the state of the asynchronous load routine
    # i.e. whether it has succeeded, failed or is still in progress.
    #
    # If {#starving?} is +true+, then you will most likely hear a
    # stuttering/repeating sound as the decode buffer loops on itself and
    # replays old data.
    # You can detect buffer under-run and use something like
    # {ChannelControl.mute} to keep it quiet until it is not starving any more.
    class OpenState

      private_class_method :new

      ##
      # Opened and ready to play.
      READY = 0
      ##
      # Initial load in progress.
      LOADING = 1
      ##
      # Failed to open - file not found, out of memory etc.
      ERROR = 2
      ##
      # Connecting to remote host (internet sounds only).
      CONNECTING = 3
      ##
      # Buffering data.
      BUFFERING = 4
      ##
      # Seeking to subsound and re-flushing stream buffer.
      SEEKING = 5
      ##
      # Ready and playing, but not possible to release at this time without
      # stalling the main thread.
      PLAYING = 6
      ##
      # Seeking within a stream to a different position.
      SET_POSITION = 7

      ##
      # @return [Integer] the open state of a sound.
      #
      #   Will be one of the following:
      #   * {READY}
      #   * {LOADING}
      #   * {ERROR}
      #   * {CONNECTING}
      #   * {BUFFERING}
      #   * {SEEKING}
      #   * {PLAYING}
      #   * {SET_POSITION}
      attr_reader :state

      ##
      # @return [Float] the percentage of the file buffer filled progress of a
      #   stream.
      attr_reader :buffered

      ##
      # The disk busy state of a sound.
      # @return [Boolean] +true+ if disk is currently being accessed for the
      #   sound, otherwise +false+.
      def busy?
        @busy != 0
      end

      ##
      # The starving state of a sound.
      # @return [Boolean] +true+ f a stream has decoded more than the stream
      #   file buffer has ready for it, otherwise +false+.
      def starving?
        @starving != 0
      end

      # @api private
      def initialize(state, buffered, busy, starving)
        @state, @buffered, @busy, @starving = state, buffered, busy, starving
      end
    end

    ##
    # @!attribute mode
    # Sets or alters the mode of a sound.
    #
    # When calling this function, note that it will only take effect when the
    # sound is played again with {#play}. Consider this mode the "default mode"
    # for when the sound plays, not a mode that will suddenly change all
    # currently playing instances of this sound.
    #
    # Supported flags:
    # * {Mode::LOOP_OFF}
    # * {Mode::LOOP_NORMAL}
    # * {Mode::LOOP_BIDI}
    # * {Mode::TWO_D}
    # * {Mode::THREE_D}
    # * {Mode::HEAD_RELATIVE_3D}
    # * {Mode::WORLD_RELATIVE_3D}
    # * {Mode::INVERSE_ROLLOFF_3D}
    # * {Mode::LINEAR_ROLLOFF_3D}
    # * {Mode::LINEAR_SQUARE_ROLLOFF_3D}
    # * {Mode::CUSTOM_ROLLOFF_3D}
    # * {Mode::IGNORE_GEOMETRY_3D}
    #
    # @return [Integer]
    integer_reader(:mode, :Sound_GetMode)
    integer_writer(:mode=, :Sound_SetMode)

    ##
    # @!attribute loop_count
    # Sets a sound, by default, to loop a specified number of times before
    # stopping if its mode is set to {Mode::LOOP_NORMAL} or {Mode::LOOP_BIDI}.
    # @return [Integer] the number of times to loop a sound before stopping.
    integer_reader(:loop_count, :Sound_GetLoopCount)
    integer_writer(:loop_count=, :Sound_SetLoopCount, -1)

    ##
    # @!attribute [r] subsound_count
    # @return [Integer] the number of subsounds stored within a sound.
    integer_reader(:subsound_count, :Sound_GetNumSubSounds)

    ##
    # @!attribute [r] syncpoint_count
    # Retrieves the number of sync points stored within a sound. These points
    # can be user generated or can come from a wav file with embedded markers.
    # @return Retrieves the number of sync points stored within a sound.
    integer_reader(:syncpoint_count, :Sound_GetNumSyncPoints)

    ##
    # @!attribute [r] name
    # @return [String] the name of the sound.
    def name
      FMOD.invoke(:Sound_GetName, self, buffer = "\0" * 512, 512)
      buffer.delete("\0")
    end

    ##
    # @!attribute [r] tags
    # @return [TagCollection] object containing the tags within the {Sound}.
    def tags
      TagCollection.send(:new, self)
    end

    ##
    # @!attribute group
    # @return [SoundGroup] the sound's current {SoundGroup}.
    def group
      FMOD.invoke(:Sound_GetSoundGroup, self, group = int_ptr)
      SoundGroup.new(group)
    end

    def group=(group)
      FMOD.type?(group, SoundGroup)
      FMOD.invoke(:Sound_SetSoundGroup, self, group)
    end

    ##
    # @!attribute [r] parent
    # @return [System] the parent {System} object that was used to create this
    #   object.
    def parent
      FMOD.invoke(:Sound_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    ##
    # Retrieves a handle to a {Sound} object that is contained within the parent
    # sound.
    # @param index [Integer] Index of the subsound to retrieve within this
    #   sound.
    # @return [Sound, nil] the subsound, or +nil+
    def subsound(index)
      return nil unless index.between?(0, subsound_count - 1)
      FMOD.invoke(:Sound_GetSubSound, self, index, sound = int_ptr)
      Sound.new(sound)
    end

    ##
    # @!attribute [r] subsounds
    # @return [Array<Sound>] an array of the this sound's subsounds.
    def subsounds
      (0...subsound_count).map { |i| subsound(i) }
    end

    ##
    # Enumerates each subsound within this {Sound}.
    # @overload each_subsound
    #   When block is given, yields each subsound before returning self.
    #   @yield [sound] Yields a sound to the block.
    #   @yieldparam sound [Sound] The current sound being enumerated.
    #   @return [self]
    # @overload each_subsound
    #   When no block is given, returns an enumerator for the subsounds.
    #   @return [Enumerator]
    def each_subsound
      return to_enum(:each_subsound) unless block_given?
      (0...subsound_count).each { |i| yield subsound(i) }
      self
    end

    ##
    # @!attribute [r] parent_sound
    # @return [Sound, nil]  the parent {Sound} of this sound, or +nil+ if this
    #   sound is not a subsound.
    def parent_sound
      FMOD.invoke(:Sound_GetSubSoundParent, self, sound = "\0" * int_ptr)
      address = sound.unpack1('J')
      address.zero? ? nil : Sound.new(address)
    end

    ##
    # Retrieve a handle to a sync point. These points can be user generated or
    # can come from a wav file with embedded markers.
    # @param index [Integer] Index of the sync point to retrieve.
    # @return [Pointer] the sync point handle.
    def syncpoint(index)
      return nil unless index.between?(0, syncpoint_count - 1)
      FMOD.invoke(:Sound_GetSyncPoint, self, index, sync = int_ptr)
      Pointer.new(sync.unpack1('J'))
    end

    ##
    # Adds a sync point at a specific time within the sound. These points can be
    # user generated or can come from a wav file with embedded markers.
    # @param name [String] A name character string to be stored with the sync
    #   point.
    # @param offset [Integer] Offset to add the callback sync-point for a sound.
    # @param unit [Integer] Offset type to describe the offset provided.
    #   @see TimeUnit
    # @return [Pointer] The sync point handle.
    def add_syncpoint(name, offset, unit = TimeUnit::MS)
      sync = int_ptr
      FMOD.invoke(:Sound_AddSyncPoint, self, offset, unit, name, sync)
      Pointer.new(sync.unpack1('J'))
    end

    ##
    # Deletes a syncpoint within the sound. These points can be user generated
    # or can come from a wav file with embedded markers.
    # @param sync_point [Pointer] A sync point handle.
    # @return [void]
    def delete_syncpoint(sync_point)
      FMOD.type?(sync_point, Pointer)
      FMOD.invoke(:Sound_DeleteSyncPoint, self, sync_point)
    end

    ##
    # @!attribute [r] format
    # @return [Format] the format information for the sound.
    def format
      arg = ["\0" * TYPE_INT, "\0" * TYPE_INT, "\0" * TYPE_INT, "\0" * TYPE_INT]
      FMOD.invoke(:Sound_GetFormat, self, *arg)
      arg.map! { |a| a.unpack1('l') }
      Format.new(*arg)
    end

    # @!group Reading Sound Data

    ##
    # Returns a pointer to the beginning of the sample data for a sound.
    #
    # With this function you get access to the RAW audio data, for example 8,
    # 16, 24 or 32-bit PCM data, mono or stereo data. You must take this into
    # consideration when processing the data within the pointer.
    #
    # @overload lock(offset, length)
    #   If called with a block, yields the pointers to the first and second
    #   sections of locked data before unlocking and returning +self+.
    #   @yield [ptr1, ptr2] Yields two pointers to the block.
    #   @yieldparam ptr1 [Pointer] Pointer to the first part of the locked data,
    #     and its size set to the number of locked bytes.
    #   @yieldparam ptr2 [Pointer] The second pointer will point to the second
    #     part of the locked data. This will be {FMOD::NULL} if the data locked
    #     hasn't wrapped at the end of the buffer, and its size will be 0.
    #   @return [self]
    # @overload lock(offset, length)
    #   If called without a block, returns the pointers in an array, and
    #   {#unlock} must be called.
    #   @return [Array(Pointer, Pointer)] An array containing two pointers.
    #
    #     The first pointer will point to the first part of the locked data, and
    #     its size set to the number of locked bytes.
    #
    #     The second pointer will point to the second part of the locked data.
    #     This will be {FMOD::NULL} if the data locked hasn't wrapped at the end
    #     of the buffer, and its size will be 0.
    #
    # @param offset [Integer] Offset in bytes to the position to lock in the
    #   sample buffer.
    # @param length [Integer] Number of bytes you want to lock in the sample
    #   buffer.
    #
    # @see unlock
    def lock(offset, length)
      p1, p2, s1, s2 = int_ptr, int_ptr, "\0" * TYPE_INT, "\0" * TYPE_INT
      FMOD.invoke(:Sound_Lock, self, offset, length, p1, p2, s1, s2)
      ptr1 = Pointer.new(p1.unpack1('J'), s1.unpack1('L'))
      ptr2 = Pointer.new(p2.unpack1('J'), s2.unpack1('L'))
      if block_given?
        yield ptr1, ptr2
        FMOD.invoke(:Sound_Unlock, self, ptr1, ptr2, ptr1.size, ptr2.size)
        return self
      end
      [ptr1, ptr2]
    end

    ##
    # Releases previous sample data lock from {#lock}.
    #
    # @note This function should not be called if a block was passed to {#lock}.
    #
    # @param ptr1 [Pointer] Pointer to the first locked portion of sample data,
    #   from {#lock}.
    # @param ptr2 [Pointer] Pointer to the second locked portion of sample data,
    #   from {#lock}.
    # @see lock
    # @return [void]
    def unlock(ptr1, ptr2)
      FMOD.invoke(:Sound_Unlock, self, ptr1, ptr2, ptr1.size, ptr2.size)
    end

    ##
    # Reads data from an opened sound to a buffer, using the FMOD codec created
    # internally, and returns it.
    #
    # This can be used for decoding data offline in small pieces (or big
    # pieces), rather than playing and capturing it, or loading the whole file
    # at once and having to {#lock} / {#unlock} the data. If too much data is
    # read, it is possible an EOF error will be thrown, meaning it is out of
    # data. The "read" parameter will reflect this by returning a smaller number
    # of bytes read than was requested. To avoid an error, simply compare the
    # size of the returned buffer against what was requested before calling
    # again.
    #
    # As a sound already reads the whole file then closes it upon calling
    # {System.create_sound} (unless {System.create_stream} or
    # {Mode::CREATE_STREAM} is used), this function will not work because the
    # file is no longer open.
    #
    # Note that opening a stream makes it read a chunk of data and this will
    # advance the read cursor. You need to either use {Mode::OPEN_ONLY} to stop
    # the stream pre-buffering or call {#seek_data} to reset the read cursor.
    #
    # If {Mode::OPEN_ONLY} flag is used when opening a sound, it will leave the
    # file handle open, and FMOD will not read any data internally, so the read
    # cursor will be at position 0. This will allow the user to read the data
    # from the start.
    #
    # As noted previously, if a sound is opened as a stream and this function is
    # called to read some data, then you will 'miss the start' of the sound.
    #
    # {Channel.position} will have the same result. These function will flush
    # the stream buffer and read in a chunk of audio internally. This is why if
    # you want to read from an absolute position you should use Sound::seekData
    # and not the previously mentioned functions.
    #
    # Remember if you are calling readData and seekData on a stream it is up to
    # you to cope with the side effects that may occur. Information functions
    # such as {Channel.position} may give misleading results. Calling
    # {Channel.position} will reset and flush the stream, leading to the time
    # values returning to their correct position.
    #
    # @param size [Integer] The number of bytes to read into the buffer.
    # @return [String] A binary string containing the buffer data. The data will
    #   be the size specified unless it has reached the end of the data, in
    #   which case it will be less, and trimmed to length.
    # @see seek_data
    def read_data(size)
      buffer = "\0" * size
      read = "\0" * SIZEOF_INT
      FMOD.invoke(:Sound_ReadData, self, buffer, size, read)
      read = read.unpack1('L')
      read < size ? buffer.byteslice(0, read) : buffer
    end

    ##
    # Seeks a sound for use with data reading.
    #
    # If a stream is opened and this function is called to read some data, then
    # it will advance the internal file pointer, so data will be skipped if you
    # play the stream. Also calling position / time information functions will
    # lead to misleading results.
    #
    # A stream can be reset before playing by setting the position of the
    # channel (ie using {Channel.position}), which will make it seek, reset and
    # flush the stream buffer. This will make it sound correct again.
    #
    # Remember if you are calling {#read_data} and {#seek_data} on a stream it
    # is up to you to cope with the side effects that may occur.
    #
    # @note This is not a function to "seek a sound" for normal use. This is for
    #   use in conjunction with {#read_data}.
    # @param pcm [Integer] Offset to seek to in PCM samples.
    # @return [void]
    # @see read_data
    def seek_data(pcm)
      FMOD.invoke(:Sound_SeekData, self, pcm)
    end

    # @!endgroup

    # @!group 3-D Sound

    ##
    # @!attribute cone_settings
    # The angles that define the sound projection cone including the volume when
    # outside the cone.
    # @return [ConeSettings] the sound projection cone.
    def cone_settings
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:Sound_Get3DConeSettings, self, *args)
      ConeSettings.new(*args.map { |arg| arg.unpack1('f') } )
    end

    def cone_settings=(settings)
      FMOD.type?(settings, ConeSettings)
      set_cone(*settings.values)
      settings
    end

    ##
    # Sets the angles that define the sound projection cone including the volume
    # when outside the cone.
    # @param inside_angle [Float] Inside cone angle, in degrees. This is the
    #   angle within which the sound is at its normal volume.
    # @param outside_angle [Float] Outside cone angle, in degrees. This is the
    #   angle outside of which the sound is at its outside volume.
    # @param outside_volume [Float] Cone outside volume.
    # @return [void]
    def set_cone(inside_angle, outside_angle, outside_volume)
      if outside_angle < inside_angle
        raise Error, 'Outside angle must be greater than inside angle.'
      end
      FMOD.invoke(:Sound_Set3DConeSettings, self, inside_angle,
        outside_angle, outside_volume)
      self
    end

    ##
    # @!attribute custom_rolloff
    #  A custom rolloff curve to define how audio will attenuate over distance.
    #
    # Must be used in conjunction with {Mode::CUSTOM_ROLLOFF_3D} flag to be
    # activated.
    #
    # <b>Points must be sorted by distance! Passing an unsorted list to FMOD
    # will result in an error.</b>
    # @return [Array<Vector>] the rolloff curve.

    def custom_rolloff
      count = "\0" * SIZEOF_INT
      FMOD.invoke(:Sound_Get3DCustomRolloff, self, nil, count)
      count = count.unpack1('l')
      return [] if count.zero?
      size = SIZEOF_FLOAT * 3
      FMOD.invoke(:Sound_Get3DCustomRolloff, self, ptr = int_ptr, nil)
      buffer = Pointer.new(ptr.unpack1('J'), count * size).to_str
      (0...count).map { |i| Vector.new(*buffer[i * size, size].unpack('fff')) }
    end

    def custom_rolloff=(rolloff)
      FMOD.type?(rolloff, Array)
      vectors = rolloff.map { |vector| vector.to_str }.join
      FMOD.invoke(:Sound_Set3DCustomRolloff, self, vectors, rolloff.size)
      rolloff
    end

    ##
    # @!attribute min_distance
    # @return [Float] Minimum volume distance in "units". (Default: 1.0)
    # @see max_distance
    # @see min_max_distance

    def min_distance
      min = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Sound_Get3DMinMaxDistance, self, min, nil)
      min.unpack1('f')
    end

    def min_distance=(distance)
      min_max_distance(distance, max_distance)
    end

    ##
    # @!attribute max_distance
    # @return [Float] Maximum volume distance in "units". (Default: 10000.0)
    # @see min_distance
    # @see in_max_distance

    def max_distance
      max = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Sound_Get3DMinMaxDistance, self, nil, max)
      max.unpack1('f')
    end

    def max_distance=(distance)
      min_max_distance(min_distance, distance)
    end

    ##
    # Sets the minimum and maximum audible distance.
    #
    # When the listener is in-between the minimum distance and the sound source
    # the volume will be at its maximum. As the listener moves from the minimum
    # distance to the maximum distance the sound will attenuate following the
    # rolloff curve set. When outside the maximum distance the sound will no
    # longer attenuate.
    #
    # Minimum distance is useful to give the impression that the sound is loud
    # or soft in 3D space. An example of this is a small quiet object, such as a
    # bumblebee, which you could set a small minimum distance such as 0.1. This
    # would cause it to attenuate quickly and disappear when only a few meters
    # away from the listener. Another example is a jumbo jet, which you could
    # set to a minimum distance of 100.0 causing the volume to stay at its
    # loudest until the listener was 100 meters away, then it would be hundreds
    # of meters more before it would fade out.
    #
    # Maximum distance is effectively obsolete unless you need the sound to stop
    # fading out at a certain point. Do not adjust this from the default if you
    # dont need to. Some people have the confusion that maximum distance is the
    # point the sound will fade out to zero, this is not the case.
    #
    # @param min [Float] Minimum volume distance in "units".
    #   * *Default:* 1.0
    # @param max [Float] Maximum volume distance in "units".
    #   * *Default:* 10000.0
    #
    # @see min_distance
    # @see max_distance
    # @return [void]
    def min_max_distance(min, max)
      FMOD.invoke(:Sound_Set3DMinMaxDistance, self, min, max)
    end

    # @!endgroup

    ##
    # @!attribute default_frequency
    # The sounds's default frequency, so when it is played it uses this value
    # without having to specify them later for each channel each time the sound
    # is played.
    # @return [Float] the default playback frequency, in hz. (ie 44100hz).

    def default_frequency
      value = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Sound_GetDefaults, self, value, nil)
      value.unpack1('f')
    end

    def default_frequency=(frequency)
      FMOD.invoke(:Sound_SetDefaults, self, frequency, default_priority)
    end

    ##
    # @!attribute default_priority
    # The sounds's default priority, so when it is played it uses this value
    # without having to specify them later for each channel each time the sound
    # is played.
    # @return [Integer] the default priority when played on a channel.
    #   * *Minimum:* 0 (most important)
    #   * *Maximum:* 256 (least important)
    #   * Default:* 128

    def default_priority
      value = "\0" * SIZEOF_INT
      FMOD.invoke(:Sound_GetDefaults, self, nil, value)
      value.unpack1('l')
    end

    def default_priority=(priority)
      priority = priority.clamp(0, 256)
      FMOD.invoke(:Sound_SetDefaults, self, default_frequency, priority)
    end

    ##
    # Retrieves the length of the sound using the specified time unit.
    # @param unit [Integer] Time unit retrieve into the length parameter.
    #   @see TimeUnit
    # @return [Integer] the length in the requested units.
    def length(unit = TimeUnit::MS)
      value = "\0" * SIZEOF_INT
      FMOD.invoke(:Sound_GetLength, self, value, unit)
      value.unpack1('L')
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
      FMOD.invoke(:Sound_GetLoopPoints, self, loop_start,
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
    #
    # @return [void]
    def set_loop(loop_start, loop_end, start_unit = TimeUnit::MS, end_unit = TimeUnit::MS)
      FMOD.invoke(:Sound_SetLoopPoints, self, loop_start,
        start_unit, loop_end, end_unit)
    end

    # @!group MOD/S3M/XM/IT/MIDI

    ##
    # @!attribute music_speed
    # The relative speed of MOD/S3M/XM/IT/MIDI music.
    #   * *Minimum:* 0.01
    #   * *Maximum:* 100.0
    #   * *Default:* 1.0
    # 0.5 is half speed, 2.0 is double speed, etc.
    # @return [Float] the relative speed of the song.
    float_reader(:music_speed, :Sound_GetMusicSpeed)
    float_writer(:music_speed=, :Sound_SetMusicSpeed)

    ##
    # Retrieves the volume of a MOD/S3M/XM/IT/MIDI music channel volume.
    # @param channel [Integer] MOD/S3M/XM/IT/MIDI music sub-channel to retrieve
    #   the volume for.
    # @return [Float] the volume of the channel from 0.0 to 1.0.
    #   * *Default:* 1.0
    # @see set_music_volume
    def music_volume(channel)
      volume = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Sound_GetMusicChannelVolume, self, channel, volume)
      volume.unpack1('f')
    end

    ##
    # Sets the volume of a MOD/S3M/XM/IT/MIDI music channel volume.
    # @param channel [Integer] MOD/S3M/XM/IT/MIDI music sub-channel to set a
    #   linear volume for.
    # @param volume [Float] Volume of the channel.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    # @return [void]
    def set_music_volume(channel, volume)
      volume = volume.clamp(0.0, 1.0)
      FMOD.invoke(:Sound_SetMusicChannelVolume, self, channel, volume)
    end

    ##
    # @!attribute [r] music_channels
    # @return [Integer] the number of channels inside a MOD/S3M/XM/IT/MIDI file.
    integer_reader(:music_channels, :Sound_GetMusicNumChannels)

    # @!endgroup

    ##
    # Retrieves the state a sound is in after {Mode::NON_BLOCKING} has been used
    # to open it, or the state of the streaming buffer.
    #
    # @return [OpenState] the current state of the sound.
    def open_state
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:Sound_GetOpenState, self, *args)
      args = args.join.unpack('lLll')
      OpenState.send(:new, *args)
    end

    ##
    # Retrieves information on an embedded sync point. These points can be user
    # generated or can come from a wav file with embedded markers.
    # @param syncpoint [Pointer] A handle to a sync-point.
    # @param time_unit [Integer] A {TimeUnit} parameter to determine a desired
    #   format for the offset parameter.
    # @return [Array(String, Integer)] array containing the name of the
    #   sync-point and the offset in the requested time unit.
    # @see TimeUnit
    def syncpoint_info(syncpoint, time_unit = TimeUnit::MS)
      name, offset = "\0" * 256, "\0" * SIZEOF_INT
      FMOD.invoke(:Sound_GetSyncPointInfo, self, syncpoint,
        name, 256, offset, time_unit)
      [name.delete("\0"), offset.unpack1('L')]
    end

    ##
    # Plays a sound object on a particular channel and {ChannelGroup}.
    #
    # When a sound is played, it will use the sound's default frequency and
    # priority.
    #
    # A sound defined as {Mode::THREE_D} will by default play at the position of
    # the listener.
    #
    # Channels are reference counted. If a channel is stolen by the FMOD
    # priority system, then the handle to the stolen voice becomes invalid, and
    # Channel based commands will not affect the new sound playing in its place.
    # If all channels are currently full playing a sound, FMOD will steal a
    # channel with the lowest priority sound. If more channels are playing than
    # are currently available on the sound-card/sound device or software mixer,
    # then FMOD will "virtualize" the channel. This type of channel is not
    # heard, but it is updated as if it was playing. When its priority becomes
    # high enough or another sound stops that was using a real hardware/software
    # channel, it will start playing from where it should be. This technique
    # saves CPU time (thousands of sounds can be played at once without actually
    # being mixed or taking up resources), and also removes the need for the
    # user to manage voices themselves. An example of virtual channel usage is a
    # dungeon with 100 torches burning, all with a looping crackling sound, but
    # with a sound-card that only supports 32 hardware voices. If the 3D
    # positions and priorities for each torch are set correctly, FMOD will play
    # all 100 sounds without any "out of channels" errors, and swap the real
    # voices in and out according to which torches are closest in 3D space.
    # Priority for virtual channels can be changed in the sound's defaults, or
    # at runtime with {Channel.priority}.
    #
    # @param group [ChannelGroup] The {ChannelGroup} become a member of. This is
    #   more efficient than later setting with {Channel.group}, as it does it
    #   during the channel setup, rather than connecting to the master channel
    #   group, then later disconnecting and connecting to the new {ChannelGroup}
    #   when specified. Specify +nil+ to ignore (use master {ChannelGroup}).
    # @return [Channel] the newly playing channel.
    def play(group = nil)
      parent.play_sound(self, group, false)
    end

    
    class TagCollection

      include Enumerable

      private_class_method :new

      def initialize(sound)
        @sound = sound
      end

      def each
        return to_enum(:each) unless block_given?
        (0...count).each { |i| yield self[i] }
        self
      end

      def count
        buffer = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:Sound_GetNumTags, @sound, buffer, nil)
        buffer.unpack1('l')
      end

      alias_method :size, :count

      def updated_count
        buffer = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:Sound_GetNumTags, @sound, nil, buffer)
        buffer.unpack1('l')
      end

      def [](index)
        tag = FMOD::Core::Tag.new
        if index.is_a?(Integer)
          return nil unless index.between?(0, count - 1)
          FMOD.invoke(:Sound_GetTag, @sound, nil, index, tag)
        elsif tag.is_a?(String)
          FMOD.invoke(:Sound_GetTag, @sound, index, 0, tag)
        end
        tag
      end
    end
  end
end