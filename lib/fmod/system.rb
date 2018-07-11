

module FMOD

  ##
  # The primary central class of FMOD. This class acts as a factory for creation
  # of other core FMOD objects, and a centralized control interface. All core
  # FMOD objects belong to a System object.
  class System < Handle

    ##
    # Contains values for describing the current CPU time used by FMOD.
    #
    # @attr dsp [Float] The current DSP mixing engine CPU usage. Result will be
    #   from 0.0 to 100.0.
    # @attr stream [Float] The current streaming engine CPU usage. Result will
    #   be from 0.0 to 100.0.
    # @attr geometry [Float] The current geometry engine CPU usage. Result will
    #   be from 0.0 to 100.0.
    # @attr update [Float] The current System::update CPU usage. Result will be
    #   from 0.0 to 100.0.
    # @attr total [Float] The current total CPU usage. Result will be from 0 to
    #   100.0.
    CpuUsage = Struct.new(:dsp, :stream, :geometry, :update, :total)

    ##
    # Contains the amount of dedicated sound ram available if the platform
    # supports it.
    # @attr current [Integer] The currently allocated sound RAM memory at time
    #   of call.
    # @attr max [Integer] The maximum allocated sound RAM memory since the
    #   System was created.
    # @attr total [Integer] The total amount of sound RAM available on this
    #   device.
    RamUsage = Struct.new(:current, :max, :total)

    ##
    # Contains information about file reads by FMOD.
    # @attr sample [Integer] The total bytes read from file for loading
    #   sample data.
    # @attr stream [Integer] The total bytes read from file for streaming
    #   sounds.
    # @attr other [Integer] The total bytes read for non-audio data such
    #   as FMOD Studio banks.
    FileUsage = Struct.new(:sample, :stream, :other)

    # Represents a logical position of a speaker.
    # @attr index [Integer] The index of the speaker.
    # @attr x [Float] The x-coordinate of the speaker.
    # @attr y [Float] The y-coordinate of the speaker.
    # @attr active [Boolean] +true+ if speaker will be enabled,
    #   otherwise +false+.
    Speaker = Struct.new(:index, :x, :y, :active)

    ##
    # Defines the information to display for the selected plugin.
    # @attr handle [Integer] The plugin handle.
    # @attr type [Integer] The type of the plugin.
    # @attr name [String] The name of the plugin.
    # @attr version [Integer] The version number set by the plugin.
    Plugin = Struct.new(:handle, :type, :name, :version)

    # Describes the output format for the software mixer.
    # @attr sample_rate [Integer] The rate in Hz, that the software mixer will
    #   run at. Specify values between 8000 and 192000.
    # @attr speaker_mode [Integer] Speaker setup for the software mixer.
    # @attr raw_channels [Integer] Number of output channels / speakers to
    #   initialize the sound card to in raw speaker mode.
    SoftwareFormat = Struct.new(:sample_rate, :speaker_mode, :raw_channels)

    ##
    # The buffer size settings for the FMOD software mixing engine.
    # @attr size [Integer] The mixer engine block size in samples. Default is
    #   1024. (milliseconds = 1024 at 48khz = 1024 / 48000 * 1000 = 10.66ms).
    # @attr count [Integer] The mixer engine number of buffers used. Default is
    #   4. To get the total buffer size multiply the buffer length by the number
    #   of buffers. By default this would be 4*1024.
    DspBuffer = Struct.new(:size, :count)

    ##
    # The internal buffer size for streams opened after this call. Larger values
    # will consume more memory, whereas smaller values may cause buffer
    # under-run/starvation/stuttering caused by large delays in disk access (ie
    # net-stream), or CPU usage in slow machines, or by trying to play too many
    # streams at once.
    # @attr size [Integer] The size of stream file buffer. Default is 16384.
    # @attr type [Integer] Type of unit for stream file buffer size.
    #   @see TimeUnit
    StreamBuffer = Struct.new(:size, :type)

    ##
    # @param address [Pointer, Integer, String] The address of a native FMOD
    #   pointer.
    def initialize(address)
      super
      @rolloff_callbacks = []
      sig = [TYPE_VOIDP, TYPE_FLOAT]
      abi = FMOD::ABI
      cb = Closure::BlockCaller.new(TYPE_FLOAT, sig, abi) do |channel, distance|
        unless @rolloff_callbacks.empty?
          chan = Channel.new(channel)
          @rolloff_callbacks.each { |proc| proc.call(chan, distance) }
        end
        distance
      end
      FMOD.invoke(:System_Set3DRolloffCallback, self, cb)
    end

    ##
    # When FMOD wants to calculate 3D volume for a channel, this callback can be
    # used to override the internal volume calculation based on distance.
    #
    # @param proc [Proc] Proc to call. Optional, must give block if nil.
    # @yield [index] The block to call when rolloff is calculated.
    # @return [void]
    def on_rolloff(proc = nil, &block)
      cb = proc || block
      raise LocalJumpError, "No block given."  if cb.nil?
      @rolloff_callbacks << cb
    end

    # @group Speaker Positioning

    ##
    # Generates a "default" matrix based on the specified source and target
    # speaker mode.
    #
    # @param source [Integer] The speaker mode being converted from.
    # @param target [Integer] The speaker mode being converted to.
    #
    # @note _source_ and _target_ must not exceed {FMOD::MAX_CHANNEL_WIDTH}.
    # @see FMOD::MAX_CHANNEL_WIDTH
    # @see SpeakerMode
    #
    # @return [<Array<Array<Float>>] the mix matrix.
    def default_matrix(source, target)
      max = FMOD::MAX_CHANNEL_WIDTH
      raise RangeError, "source channels cannot exceed #{max}" if source > max
      raise RangeError, "target channels cannot exceed #{max}" if target > max
      return [] if source < 1 || target < 1
      buffer = "\0" * (SIZEOF_FLOAT * source * target)
      FMOD.invoke(:System_GetDefaultMixMatrix, self, source, target, buffer, 0)
      buffer.unpack('f*').each_slice(source).to_a
    end

    ##
    # Helper function to return the speakers as array.
    # @return [Array<Speaker>] the array of speakers.
    def speakers
      each_speaker.to_a
    end

    ##
    # @return [Speaker] the current speaker position for the selected speaker.
    # @see SpeakerIndex
    def speaker(index)
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_INT ]
      FMOD.invoke(:System_GetSpeakerPosition, self, index, *args)
      args = [index] + args.join.unpack('ffl')
      args[3] = args[3] != 0
      Speaker.new(*args)
    end

    ##
    # This function allows the user to specify the position of their actual
    # physical speaker to account for non standard setups.
    #
    # It also allows the user to disable speakers from 3D consideration in a
    # game.
    #
    # The function is for describing the "real world" speaker placement to
    # provide a more natural panning solution for 3D sound. Graphical
    # configuration screens in an application could draw icons for speaker
    # placement that the user could position at their will.
    #
    # @overload set_speaker(speaker)
    #   @param speaker [Speaker] The speaker to set.
    # @overload set_speaker(index, x, y, active = true)
    #   @param index [Integer] The index of the speaker to set.
    #     @see SpeakerIndex
    #   @param x [Float] The 2D X position relative to the listener.
    #   @param y [Float] The 2D Y position relative to the listener.
    #   @param active [Boolean] The active state of a speaker.
    # @return [void]
    def set_speaker(*args)
      unless [1, 3, 4].include?(args.size)
        message = "wrong number of arguments: #{args.size} for 1, 3, or 4"
        raise ArgumentError, message
      end
      index, x, y, active = args[0].is_a?(Speaker) ? args[0].values : args
      active = true if args.size == 3
      FMOD.invoke(:System_SetSpeakerPosition, self, index, x, y, active.to_i)
    end

    ##
    # @overload each_speaker
    #   When called with a block, yields each speaker in turn before returning
    #   self.
    #   @yield [speaker] Yields a speaker to the block.
    #   @yieldparam speaker [Speaker] The current enumerated speaker.
    #   @return [self]
    # @overload each_speaker
    #   When called without a block, returns an enumerator for the speakers.
    #   @return [Enumerator]
    def each_speaker
      return to_enum(:each_speaker) unless block_given?
      SpeakerIndex.constants(false).each do |const|
        index = SpeakerIndex.const_get(const)
        yield speaker(index) rescue next
      end
      self
    end

    # @!endgroup

    # @!group Object Creation

    ##
    # @note <b>This must be called to create an {System} object before you can
    #   do anything else.</b>
    #
    # {System} creation function. Use this function to create one, or
    # multiple instances of system objects.
    # @param options [Hash] Options hash.
    # @option options [Integer] :max_channels (32) The maximum number of
    #   channels to be used in FMOD. They are also called "virtual channels" as
    #   you can play as many of these as you want, even if you only have a small
    #   number of software voices.
    # @option options [Integer] :flags (InitFlags::NORMAL) See {InitFlags}. This
    #   can be a selection of flags bitwise OR'ed together to change the
    #   behavior of FMOD at initialization time.
    # @option options [Pointer|String] :driver_data (FMOD::NULL) Driver
    #   specific data that can be passed to the output plugin. For example the
    #   filename for the wav writer plugin.
    # @return [System] the newly created {System} object.
    def self.create(**options)
      max = [options[:max_channels] || 32, 4093].min
      flags = options[:flags] || InitFlags::NORMAL
      driver = options[:driver_data] || FMOD::NULL
      FMOD.invoke(:System_Create, address = "\0" * SIZEOF_INTPTR_T)
      system = new(address)
      FMOD.invoke(:System_Init, system, max, flags, driver)
      system
    end

    ##
    # Loads a sound into memory, or opens it for streaming.
    #
    # @param source [String, Pointer] Name of the file or URL to open encoded in
    #   a UTF-8 string, or a pointer to a pre-loaded sound memory block if
    #   {Mode::OPEN_MEMORY} / {Mode::OPEN_MEMORY_POINT} is used.
    # @param options [Hash] Options hash.
    # @option options [Integer] :mode (Mode::DEFAULT) Behavior modifier for
    #   opening the sound. See {Mode} for explanation of flags.
    # @option options [SoundExInfo] :extra (FMOD::NULL) Extra data which lets
    #   the user provide extended information while playing the sound.
    # @return [Sound] the created sound.
    def create_sound(source, **options)
      mode = options[:mode] || Mode::DEFAULT
      extra = options[:extra] || FMOD::NULL
      sound = int_ptr
      FMOD.invoke(:System_CreateSound, self, source, mode, extra, sound)
      Sound.new(sound)
    end

    ##
    # Opens a sound for streaming. This function is a helper function that is
    # the same as {#create_sound} but has the {Mode::CREATE_STREAM} flag added
    # internally.
    #
    # @param source [String, Pointer] Name of the file or URL to open encoded in
    #   a UTF-8 string, or a pointer to a pre-loaded sound memory block if
    #   {Mode::OPEN_MEMORY} / {Mode::OPEN_MEMORY_POINT} is used.
    # @param options [Hash] Options hash.
    # @option options [Integer] :mode (Mode::DEFAULT) Behavior modifier for
    #   opening the sound. See {Mode} for explanation of flags.
    # @option options [SoundExInfo] :extra (FMOD::NULL) Extra data which lets
    #   the user provide extended information while playing the sound.
    # @return [Sound] the created sound.
    def create_stream(source, **options)
      mode = options[:mode] || Mode::DEFAULT
      extra = options[:extra] || FMOD::NULL
      sound = int_ptr
      FMOD.invoke(:System_CreateSound, self, source, mode, extra, sound)
      Sound.new(sound)
    end

    ##
    # Creates an FMOD defined built in DSP unit object to be inserted into a DSP
    # network, for the purposes of sound filtering or sound generation.
    #
    # This function is used to create special effects that come built into FMOD.
    #
    # @param type [Integer, Class] A pre-defined DSP effect or sound generator
    #   described by in {DspType}, or a Class found within the {Effects} module.
    #
    # @return [Dsp] the created DSP.
    def create_dsp(type)
      unless FMOD.type?(type, Integer, false)
        unless FMOD.type?(type, Class) && type < Dsp
          raise TypeError, "#{type} must either be or inherit from #{Dsp}."
        end
      end
      if type.is_a?(Integer)
        klass = Dsp.type_map(type)
      else type.is_a?(Class)
      klass = type
      type = Dsp.type_map(type)
      end
      dsp = int_ptr
      FMOD.invoke(:System_CreateDSPByType, self, type, dsp)
      klass.new(dsp)
    end

    ##
    # Creates a sound group, which can store handles to multiple {Sound}
    # objects.
    # @param name [String] Name of sound group.
    # @return [SoundGroup] the created {SoundGroup}.
    def create_sound_group(name)
      utf8 = name.encode('UTF-8')
      group = int_ptr
      FMOD.invoke(:System_CreateSoundGroup, self, utf8, group)
      SoundGroup.new(group)
    end

    ##
    # Geometry creation function. This function will create a base geometry
    # object which can then have polygons added to it.
    #
    # Polygons can be added to a geometry object using {Geometry.add_polygon}.
    #
    # A geometry object stores its list of polygons in a structure optimized for
    # quick line intersection testing and efficient insertion and updating. The
    # structure works best with regularly shaped polygons with minimal overlap.
    # Many overlapping polygons, or clusters of long thin polygons may not be
    # handled efficiently. Axis aligned polygons are handled most efficiently.
    #
    # The same type of structure is used to optimize line intersection testing
    # with multiple geometry objects.
    #
    # It is important to set the value of max world-size to an appropriate value
    # using {#world_size}. Objects or polygons outside the range of max
    # world-size will not be handled efficiently. Conversely, if max world-size
    # is excessively large, the structure may lose precision and efficiency may
    # drop.
    #
    # @param max_polygons [Integer] Maximum number of polygons within this
    #   object.
    # @param max_vertices [Integer] Maximum number of vertices within this
    #   object.
    def create_geometry(max_polygons, max_vertices)
      geometry = int_ptr
      FMOD.invoke(:System_CreateGeometry, self, max_polygons, max_vertices, geometry)
      Geometry.new(geometry)
    end

    ##
    # Creates a "virtual reverb" object. This object reacts to 3D location and
    # morphs the reverb environment based on how close it is to the reverb
    # object's center.
    #
    # Multiple reverb objects can be created to achieve a multi-reverb
    # environment. 1 Physical reverb object is used for all 3D reverb objects
    # (slot 0 by default).
    #
    # The 3D reverb object is a sphere having 3D attributes (position, minimum
    # distance, maximum distance) and reverb properties. The properties and 3D
    # attributes of all reverb objects collectively determine, along with the
    # listener's position, the settings of and input gains into a single 3D
    # reverb DSP. When the listener is within the sphere of effect of one or
    # more 3D reverbs, the listener's 3D reverb properties are a weighted
    # combination of such 3D reverbs. When the listener is outside all of the
    # reverbs, no reverb is applied.
    #
    # Creating multiple reverb objects does not impact performance. These are
    # "virtual reverbs". There will still be only 1 physical reverb DSP running
    # that just morphs between the different virtual reverbs.
    #
    # @return [Reverb3D] the created {Reverb3D} object.
    def create_reverb
      reverb = int_ptr
      FMOD.invoke(:System_CreateReverb3D, self, reverb)
      Reverb3D.new(reverb)
    end

    ##
    # Creates a {ChannelGroup} object. These objects can be used to assign
    # channels to for group channel settings, such as volume.
    #
    # Channel groups are also used for sub-mixing. Any channels that are
    # assigned to a channel group get sub-mixed into that channel group's DSP.
    #
    # @param name [String, nil] Optional label to give to the channel group for
    #   identification purposes.
    # @return [ChannelGroup] the created {ChannelGroup} object.
    def create_channel_group(name = nil)
      FMOD.invoke(:System_CreateChannelGroup, self, name, group = int_ptr)
      ChannelGroup.new(group)
    end

    ##
    # Creates a {Geometry} object that was previously serialized with
    # {Geometry.save}.
    # @param source [String] Either a filename where object is saved, or a
    #   binary block of serialized data.
    # @param filename [Boolean] +true+ if source is a filename to be loaded,
    #   otherwise +false+ and source will be handled as binary data.
    # @return [Geometry]
    # @see Geometry.save
    def load_geometry(source, filename = true)
      source = IO.open(source, 'rb') { |io| io.read } if filename
      size = source.bytesize
      FMOD.invoke(:System_LoadGeometry, self, source, size, geometry = int_ptr)
      Geometry.new(geometry)
    end

    # @!endgroup

    # @!group System Resources

    ##
    # Retrieves in percent of CPU time - the amount of CPU usage that FMOD is
    # taking for streaming/mixing and {#update} combined.
    #
    # @return [CpuUsage] the current CPU resource usage at the time of the call.
    def cpu_usage
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT,
        "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:System_GetCPUUsage, self, *args)
      CpuUsage.new(*args.map { |arg| arg.unpack1('f') })
    end

    ##
    # Retrieves the amount of dedicated sound ram available if the platform
    # supports it.
    #
    # Most platforms use main RAM to store audio data, so this function usually
    # isn't necessary.
    #
    # @return [RamUsage] the current RAM resource usage at the time of the call.
    def ram_usage
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:System_GetSoundRAM, self, *args)
      RamUsage.new(*args.map { |arg| arg.unpack1('l') })
    end

    ##
    # Retrieves information about file reads by FMOD.
    #
    # The values returned are running totals that never reset.
    #
    # @return [FileUsage] the current total of file read resources used by FMOD
    #   at the time of the call.
    def file_usage
      args = ["\0" * SIZEOF_LONG_LONG, "\0" * SIZEOF_LONG_LONG,
        "\0" * SIZEOF_LONG_LONG]
      FMOD.invoke(:System_GetFileUsage, self, *args)
      FileUsage.new(*args.map { |arg| arg.unpack1('q') })
    end

    # @!endgroup

    # @!group Recording

    ##
    # Stops the recording engine from recording to the specified recording
    # sound.
    #
    # This does +NOT+ raise an error if a the specified driver ID is incorrect
    # or it is not recording.
    #
    # @param driver_id [Integer] Enumerated driver ID.
    #
    # @return [void]
    def stop_recording(driver_id)
      FMOD.invoke(:System_RecordStop, self, driver_id)
    end

    ##
    # Starts the recording engine recording to the specified recording sound.
    #
    # @note The specified sound must be created with {Mode::CREATE_SAMPLE} flag.
    #
    # @param driver_id [Integer] Enumerated driver ID.
    # @param sound [Sound] User created sound for the user to record to.
    # @param loop [Boolean] Flag to tell the recording engine whether to
    #   continue recording to the provided sound from the start again, after it
    #   has reached the end. If this is set to true the data will be continually
    #   be overwritten once every loop.
    #
    # @return [void]
    def record_start(driver_id, sound, loop = false)
      FMOD.type?(sound, Sound)
      FMOD.invoke(:System_RecordStart, self, driver_id, sound, loop.to_i)
    end

    ##
    # Retrieves the state of the FMOD recording API, ie if it is currently
    # recording or not.
    #
    # @param driver_id [Integer] Enumerated driver ID.
    #
    # @return [Boolean] the current recording state of the specified driver.
    def recording?(driver_id)
      bool = "\0" * SIZEOF_INT
      FMOD.invoke(:System_IsRecording, self, driver_id, bool)
      bool.unpack1('l') != 0
    end

    ##
    # Retrieves the current recording position of the record buffer in PCM
    # samples.
    #
    # @param driver_id [Integer] Enumerated driver ID.
    #
    # @return [Integer] the current recording position in PCM samples.
    def record_position(driver_id)
      position = "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetRecordPosition, self, driver_id, position)
      position.unpack1('L')
    end

    ##
    # Retrieves the number of recording devices available for this output mode.
    #
    # Use this to enumerate all recording devices possible so that the user can
    # select one.
    #
    # @param connected [Boolean]
    #   * *true:* Retrieve the number of recording drivers currently plugged in.
    #   * *false:* Receives the number of recording drivers available for this
    #     output mode.
    #
    # @return [Integer] the number of record drivers.
    def record_driver_count(connected = true)
      total, present = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetRecordNumDrivers, self, total, present)
      (connected ? present : total).unpack1('l')
    end

    ##
    # Retrieves identification information about a sound device specified by its
    # index, and specific to the output mode set with {#output}.
    #
    # @param id [Integer] Index of the sound driver device. The total number of
    #   devices can be found with {#record_driver_count}.
    #
    # @return [Driver] the specified driver information.
    def record_driver(id)
      args = [id, "\0" * 512, 512, Guid.new] + (0...4).map { "\0" * SIZEOF_INT }
      FMOD.invoke(:System_GetRecordDriverInfo, self, *args)
      Driver.send(:new, args)
    end

    ##
    # @!attribute [r] record_drivers
    # @return [Array<Driver>] the array of available record drivers.
    def record_drivers(connected = true)
      (0...record_driver_count(connected)).map { |i| record_driver(i) }
    end

    # @!endgroup

    # @!group Sound Card Drivers

    ##
    # @!attribute output
    # The output mode for the platform. This is for selecting different OS
    # specific APIs which might have different features.
    #
    # Changing this is only necessary if you want to specifically switch away
    # from the default output mode for the operating system. The most optimal
    # mode is selected by default for the operating system.
    #
    # @see OutputMode
    # @return [Integer] the output mode for the platform.
    integer_reader(:output, :System_GetOutput)
    integer_writer(:output=, :System_SetOutput)

    ##
    # @!attribute [r] driver_count
    # @return [Integer] the number of sound-card devices on the machine,
    #   specific to the output mode set with {#output}.
    integer_reader(:driver_count, :System_GetNumDrivers)

    ##
    # @!attribute current_driver
    # @return [Integer] the currently selected driver number. 0 represents the
    #   primary or default driver.
    integer_reader(:current_driver, :System_GetDriver)
    integer_writer(:current_driver=, :System_SetDriver)

    ##
    # Retrieves identification information about a sound device specified by its
    # index, and specific to the output mode set with {#output}.
    #
    # @param id [Integer] Index of the sound driver device. The total number of
    #   devices can be found with {#driver_count}.
    #
    # @return [Driver] the driver information.
    def driver_info(id)
      args = [id, "\0" * 512, 512, Guid.new] + (0...3).map { "\0" * SIZEOF_INT }
      FMOD.invoke(:System_GetDriverInfo, self, *args)
      Driver.send(:new, args)
    end

    ##
    # @!attribute output_handle
    # Retrieves a pointer to the system level output device module. This means a
    # pointer to a DirectX "LPDIRECTSOUND", or a WINMM handle, or with something
    # like with {OutputType::NO_SOUND} output, the handle will be {FMOD::NULL}.
    #
    # @return [Pointer] the handle to the output mode's native hardware API
    #   object.
    def output_handle
      FMOD.invoke(:System_GetOutputHandle, self, handle = int_ptr)
      Pointer.new(handle.unpack1('J'))
    end

    ##
    # @!attribute [r] drivers
    # @return [Array<Driver>] the array of available drivers.
    def drivers
      (0...driver_count).map { |id| driver_info(id) }
    end

    # @!endgroup

    # @!group 3D Sound

    ##
    # @!attribute doppler_scale
    # The general scaling factor for how much the pitch varies due to doppler
    # shifting in 3D sound.
    #
    # Doppler is the pitch bending effect when a sound comes towards the
    # listener or moves away from it, much like the effect you hear when a train
    # goes past you with its horn sounding. With "doppler scale" you can
    # exaggerate or diminish the effect. FMOD's effective speed of sound at a
    # doppler factor of 1.0 is 340 m/s.
    #
    # @return [Float] the scaling factor.

    def doppler_scale
      scale = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:System_Get3DSettings, self, scale, nil, nil)
      scale.unpack1('f')
    end

    def doppler_scale=(scale)
      FMOD.invoke(:System_Set3DSettings, self, scale,
                  distance_factor, rolloff_scale)
    end

    ##
    # @!attribute distance_factor
    # The FMOD 3D engine relative distance factor, compared to 1.0 meters.
    #
    # Another way to put it is that it equates to "how many units per meter does
    # your engine have". For example, if you are using feet then "scale" would
    # equal 3.28.
    #
    # @return [Float] the relative distance factor.

    def distance_factor
      factor = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:System_Get3DSettings, self, nil, factor, nil)
      factor.unpack1('f')
    end

    def distance_factor=(factor)
      FMOD.invoke(:System_Set3DSettings, self, doppler_scale,
                  factor, rolloff_scale)
    end

    ##
    # @!attribute rolloff_scale
    # The global attenuation rolloff factor for {Mode::INVERSE_ROLLOFF_3D} based
    # sounds only (which is the default).
    #
    # Volume for a sound set to {Mode::INVERSE_ROLLOFF_3D} will scale at minimum
    # distance / distance. This gives an inverse attenuation of volume as the
    # source gets further away (or closer). Setting this value makes the sound
    # drop off faster or slower. The higher the value, the faster volume will
    # attenuate, and conversely the lower the value, the slower it will
    # attenuate. For example a rolloff factor of 1 will simulate the real world,
    # where as a value of 2 will make sounds attenuate 2 times quicker.
    #
    # @return [Float] the global rolloff factor.

    def rolloff_scale
      scale = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:System_Get3DSettings, self, nil, nil, scale)
      scale.unpack1('f')
    end

    def rolloff_scale=(scale)
      FMOD.invoke(:System_Set3DSettings, self, doppler_scale,
                  distance_factor, scale)
    end

    ##
    # Calculates geometry occlusion between a listener and a sound source.
    #
    # @param listener [Vector] The listener position.
    # @param source [Vector] The source position.
    #
    # @return [Array(Float, Float)] the occlusion values as an array, the first
    #   element being the direct occlusion value, and the second element being
    #   the reverb occlusion value.
    def geometry_occlusion(listener, source)
      FMOD.type?(listener, Vector)
      FMOD.type?(source, Vector)
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:System_GetGeometryOcclusion, self, listener, source, *args)
      args.join.unpack('ff')
    end

    ##
    # @!attribute listeners
    # The number of 3D "listeners" in the 3D sound scene. This is useful mainly
    # for split-screen game purposes.
    #
    # If the number of listeners is set to more than 1, then panning and doppler
    # are turned off. *All* sound effects will be mono. FMOD uses a "closest
    # sound to the listener" method to determine what should be heard in this
    # case.
    # * *Minimum:* 1
    # * *Maximum:* {FMOD::MAX_LISTENERS}
    # * *Default:* 1
    # @return [Integer]
    integer_reader(:listeners, :System_Get3DNumListeners)
    integer_writer(:listeners=, :System_Set3DNumListeners, 1, FMOD::MAX_LISTENERS)

    ##
    # @!attribute world_size
    # The maximum world size for the geometry engine for performance / precision
    # reasons
    #
    # This setting should be done first before creating any geometry.
    # It can be done any time afterwards but may be slow in this case.
    #
    # Objects or polygons outside the range of this value will not be handled
    # efficiently. Conversely, if this value is excessively large, the structure
    # may loose precision and efficiency may drop.
    #
    # @return [Float] the maximum world size for the geometry engine.
    float_reader(:world_size, :System_GetGeometrySettings)
    float_writer(:world_size=, :System_SetGeometrySettings)

    # @!endgroup

    # @!group Plugin Support

    ##
    # Loads an FMOD plugin. This could be a DSP, file format or output plugin.
    #
    # @param filename [String] Filename of the plugin to be loaded.
    # @param priority [Integer] Codec plugins only, priority of the codec
    #   compared to other codecs, where 0 is the most important and higher
    #   numbers are less important.
    #
    # @return [Integer] the handle to the plugin.
    def load_plugin(filename, priority = 128)
      # noinspection RubyResolve
      path = filename.encode(Encoding::UTF_8)
      handle = "\0" * SIZEOF_INT
      FMOD.invoke(:System_LoadPlugin, self, path, handle, priority)
      handle.unpack1('L')
    end

    ##
    # Unloads a plugin from memory.
    #
    # @param handle [Integer] Handle to a pre-existing plugin.
    #
    # @return [void]
    def unload_plugin(handle)
      FMOD.invoke(:System_UnloadPlugin, self, handle)
    end

    ##
    # Retrieves the number of available plugins loaded into FMOD at the current
    # time.
    #
    # @param type [Symbol] Specifies the type of plugin(s) to enumerate.
    #   * <b>:output</b> The plugin type is an output module. FMOD mixed audio
    #     will play through one of these devices
    #   * <b>:codec</b> The plugin type is a file format codec. FMOD will use
    #     these codecs to load file formats for playback.
    #   * <b>:dsp</b> The plugin type is a DSP unit. FMOD will use these plugins
    #     as part of its DSP network to apply effects to output or generate.rb
    #     sound in realtime.
    # @return [Integer] the plugin count.
    def plugin_count(type = :all)
      plugin_type = %i[output codec dsp].index(type)
      count = "\0" * SIZEOF_INT
      unless plugin_type.nil?
        FMOD.invoke(:System_GetNumPlugins, self, plugin_type, count)
        return count.unpack1('l')
      end
      total = 0
      (0..2).each do |i|
        FMOD.invoke(:System_GetNumPlugins, self, i, count)
        total += count.unpack1('l')
      end
      total
    end

    ##
    # Specify a base search path for plugins so they can be placed somewhere
    # else than the directory of the main executable.
    #
    # @param directory [String] A string containing a correctly formatted path
    #   to load plugins from.
    #
    # @return [void]
    def plugin_path(directory)
      # noinspection RubyResolve
      path = directory.encode(Encoding::UTF_8)
      FMOD.invoke(:System_SetPluginPath, self, path)
    end

    ##
    # Retrieves the handle of a plugin based on its type and relative index.
    #
    # @param type [Symbol] The type of plugin type.
    #   * <b>:output</b> The plugin type is an output module. FMOD mixed audio
    #     will play through one of these devices
    #   * <b>:codec</b> The plugin type is a file format codec. FMOD will use
    #     these codecs to load file formats for playback.
    #   * <b>:dsp</b> The plugin type is a DSP unit. FMOD will use these plugins
    #     as part of its DSP network to apply effects to output or generate.rb
    #     sound in realtime.
    # @param index [Integer] The relative index for the type of plugin.
    #
    # @return [Integer] the handle to the plugin.
    def plugin(type, index)
      handle = "\0" * SIZEOF_INT
      plugin_type = %i[output codec dsp].index(type)
      raise ArgumentError, "Invalid plugin type: #{type}." if plugin_type.nil?
      FMOD.invoke(:System_GetPluginHandle, self, plugin_type, index, handle)
      handle.unpack1('L')
    end

    ##
    # Returns nested plugin definition for the given index.
    #
    # For plugins consisting of a single definition, only index 0 is valid and
    # the returned handle is the same as the handle passed in.
    #
    # @param handle [Integer] A handle to an existing plugin returned from
    #   {#load_plugin}.
    # @param index [Integer] Index into the list of plugin definitions.
    #
    # @return [Integer] the handle to the nested plugin.
    def nested_plugin(handle, index)
      nested = "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetNestedPlugin, self, handle, index, nested)
      nested.unpack1('L')
    end

    ##
    # Returns the number of plugins nested in the one plugin file.
    #
    # Plugins normally have a single definition in them, in which case the count
    # is always 1.
    #
    # For plugins that have a list of definitions, this function returns the
    # number of plugins that have been defined. {#nested_plugin} can be used to
    # find each handle.
    #
    # @param handle [Integer] A handle to an existing plugin returned from
    #   {#load_plugin}.
    #
    # @return [Integer] the number of nested plugins.
    def nested_plugin_count(handle)
      count = "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetNumNestedPlugins, self, handle, count)
      count.unpack1('l')
    end

    ##
    # Retrieves information to display for the selected plugin.
    #
    # @param handle [Integer] The handle to the plugin.
    #
    # @return [Plugin] the plugin information.
    def plugin_info(handle)
      name, type, vs = "\0" * 512, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetPluginInfo, self, handle, type, name, 512, vs)
      type = %i[output codec dsp][type.unpack1('l')]
      # noinspection RubyResolve
      name = name.delete("\0").force_encoding(Encoding::UTF_8)
      Plugin.new(handle, type, name, FMOD.uint2version(vs))
    end

    ##
    # @!attribute plugin_output
    # @return [Integer] the currently selected output as an ID in the list of
    #   output plugins.
    integer_reader(:plugin_output, :System_GetOutputByPlugin)
    integer_writer(:plugin_output=, :System_SetOutputByPlugin)

    ##
    # @param handle [Integer] Handle to a pre-existing DSP plugin.
    # @return [DspDescription] the description structure for a pre-existing DSP
    #   plugin.
    def plugin_dsp_info(handle)
      FMOD.invoke(:System_GetDSPInfoByPlugin, self, handle, address = int_ptr)
      DspDescription.new(address)
    end

    ##
    # Enumerates the loaded plugins, optionally specifying the type of plugins
    # to loop through.
    #
    # @overload each_plugin(plugin_type = :all)
    #   When a block is passed, yields each plugin to the block in turn before
    #   returning self.
    #   @yield [plugin] Yields a plugin to the block.
    #   @yieldparam plugin [Plugin] The currently enumerated plugin.
    #   @return [self]
    # @overload each_plugin(plugin_type = :all)
    #   When no block is given, returns an enumerator for the plugins.
    #   @return [Enumerator]
    # @param plugin_type [Symbol] Specifies the type of plugin(s) to enumerate.
    #   * <b>:output</b> The plugin type is an output module. FMOD mixed audio
    #     will play through one of these devices
    #   * <b>:codec</b> The plugin type is a file format codec. FMOD will use
    #     these codecs to load file formats for playback.
    #   * <b>:dsp</b> The plugin type is a DSP unit. FMOD will use these plugins
    #     as part of its DSP network to apply effects to output or generate.rb
    #     sound in realtime.
    def each_plugin(plugin_type = :all)
      return to_enum(:each_plugin) unless block_given?
      types = plugin_type == :all ? %i[output codec dsp] : [plugin_type]
      types.each do |type|
        (0...plugin_count(type)).each do |index|
          handle = plugin(type, index)
          yield plugin_info(handle)
        end
      end
      self
    end

    # @!endgroup

    # @!group Network

    # @!attribute network_proxy
    # @return [String] proxy server to use for internet connections.

    def network_proxy
      buffer = "\0" * 512
      FMOD.invoke(:System_GetNetworkProxy, self, buffer, 512)
      # noinspection RubyResolve
      buffer.delete("\0").force_encoding(Encoding::UTF_8)
    end

    def network_proxy=(url)
      # noinspection RubyResolve
      FMOD.invoke(:System_SetNetworkProxy, self, url.encode(Encoding::UTF_8))
    end

    # @!attribute network_timeout
    # @return [Integer] the timeout, in milliseconds, for network streams.
    integer_reader(:network_timeout, :System_GetNetworkTimeout)
    integer_writer(:network_timeout=, :System_SetNetworkTimeout)

    # @!endgroup

    ##
    # Route the signal from a channel group into a separate audio port on the
    # output driver.
    #
    # Note that an FMOD port is a hardware specific reference, to hardware
    # devices that exist on only certain platforms (like a console headset, or
    # dedicated hardware music channel for example). It is not supported on all
    # platforms.
    #
    # @param group [ChannelGroup] Channel group to route away to the new port.
    # @param port_type [Integer] Output driver specific audio port type. See
    #   extra platform specific header (if it exists) for port numbers
    # @param port_index [Integer] Output driver specific index of the audio
    #   port. Use {FMOD::PORT_INDEX_NONE} if this is not required.
    # @param pass_thru [Boolean] If +true+ the signal will continue to be passed
    #   through to the main mix, if +false+ the signal will be entirely to the
    #   designated port.
    #
    # @return [void]
    def attach_to_port(group, port_type, port_index, pass_thru)
      FMOD.type?(group, ChannelGroup)
      FMOD.invoke(:System_AttachChannelGroupToPort, self, port_type,
                  port_index, group, pass_thru.to_i)
    end

    ##
    # Disconnect a channel group from a port and route audio back to the default
    # port of the output driver.
    #
    # @param group [ChannelGroup] Channel group to route away back to the
    #   default audio port.
    #
    # @return [void]
    def detach_from_port(group)
      FMOD.type?(group, ChannelGroup)
      FMOD.invoke(:System_DetachChannelGroupFromPort, self, group)
    end

    ##
    # Mutual exclusion function to lock the FMOD DSP engine (which runs
    # asynchronously in another thread), so that it will not execute. If the
    # FMOD DSP engine is already executing, this function will block until it
    # has completed.
    #
    # The function may be used to synchronize DSP network operations carried out
    # by the user.
    #
    # An example of using this function may be for when the user wants to
    # construct a DSP sub-network, without the DSP engine executing in the
    # background while the sub-network is still under construction.
    #
    # Once the user no longer needs the DSP engine locked, it must be unlocked
    # with {#unlock_dsp}.
    #
    # Note that the DSP engine should not be locked for a significant amount of
    # time, otherwise inconsistency in the audio output may result. (audio
    # skipping/stuttering).
    #
    # @overload lock_dsp
    #   Locks the DSP engine, must unlock with {#unlock_dsp}.
    # @overload lock_dsp
    #   @yield Locks the DSP engine, and unlocks it when the block exits.
    # @return [void]
    def lock_dsp
      FMOD.invoke(:System_LockDSP, self)
      if block_given?
        yield
        FMOD.invoke(:System_UnlockDSP, self)
      end
    end

    ##
    # Mutual exclusion function to unlock the FMOD DSP engine (which runs
    # asynchronously in another thread) and let it continue executing.
    #
    # @note The DSP engine must be locked with {#lock_dsp} before this function
    # is called.
    # @return [void]
    def unlock_dsp
      FMOD.invoke(:System_UnlockDSP, self)
    end

    ##
    # Helper method to create and enumerate each type of internal DSP unit.
    # @overload each_dsp
    #   When called with a block, yields each DSP type in turn before returning
    #   self.
    #   @yield [dsp] Yields a DSP unit to the block.
    #   @yieldparam dsp [Dsp] The current enumerated DSP unit.
    #   @return [self]
    # @overload each_dsp
    #   When called without a block, returns an enumerator for the DSP units.
    #   @return [Enumerator]
    def each_dsp
      return to_enum(:each_dsp) unless block_given?
      FMOD::DspType.constants(false).each do |const|
        type = DspType.const_get(const)
        yield create_dsp(type) rescue next
      end
      self
    end

    ##
    # Retrieves the number of currently playing channels.
    # @param total [Boolean] +true+ to return the number of playing channels
    #   (both real and virtual), +false+ to return the number of playing
    #   non-virtual channels only.
    # @return [Integer] the number of playing channels.
    def playing_channels(total = true)
      count, real = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetChannelsPlaying, self, count, real)
      (total ? count : real).unpack1('l')
    end

    ##
    # Retrieves a handle to a channel by ID.
    #
    # @param id [Integer] Index in the FMOD channel pool. Specify a channel
    #   number from 0 to the maximum number of channels specified in
    #   {System.create} minus 1.
    #
    # @return [Channel] the requested channel.
    def channel(id)
      FMOD.invoke(:System_GetChannel, self, id, handle = int_ptr)
      Channel.new(handle)
    end

    ##
    # @return [Integer] the a speaker mode's channel count.
    # @param speaker_mode [Integer] the speaker mode to query.
    # @see SpeakerMode
    def speaker_mode_channels(speaker_mode)
      count = "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetSpeakerModeChannels, self, speaker_mode, count)
      count.unpack1('l')
    end

    ##
    # @!attribute software_format
    # The output format for the software mixer.
    #
    # If loading Studio banks, this must be set with speaker mode
    # corresponding to the project's output format if there is a possibility of
    # the output audio device not matching the project's format. Any differences
    # between the project format and the system's speaker mode will cause the
    # mix to sound wrong.
    #
    # If not loading Studio banks, do not set this unless you explicitly want
    # to change a setting from the default. FMOD will default to the speaker
    # mode and sample rate that the OS / output prefers.
    #
    # @return [SoftwareFormat] the output format for the software mixer.

    def software_format
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:System_GetSoftwareFormat, self, *args)
      args.map! { |arg| arg.unpack1('l') }
      SoftwareFormat.new(*args)
    end

    def software_format=(format)
      FMOD.type?(format, SoftwareFormat)
      FMOD.invoke(:System_GetSoftwareFormat, self, *format.values)
    end

    ##
    # Retrieves the internal master channel group. This is the default channel
    # group that all channels play on.
    #
    # This channel group can be used to do things like set the master volume for
    # all playing sounds. See the ChannelGroup API for more functionality.
    # @return [ChannelGroup] the internal master channel group.
    def master_channel_group
      FMOD.invoke(:System_GetMasterChannelGroup, self, group = int_ptr)
      ChannelGroup.new(group)
    end

    ##
    # @@return [SoundGroup] the default sound group, where all sounds are placed
    # when they are created.
    def master_sound_group
      FMOD.invoke(:System_GetMasterSoundGroup, self, group = int_ptr)
      SoundGroup.new(group)
    end

    ##
    # Closes the {System} object without freeing the object's memory, so the
    # system handle will still be valid.
    #
    # Closing the output renders objects created with this system object
    # invalid. Make sure any sounds, channel groups, geometry and DSP objects
    # are released before closing the system object.
    #
    # @return [void]
    def close
      FMOD.invoke(:System_Close, self)
    end

    ##
    # @!attribute [r] version
    # @return [String] the current version of FMOD being used.
    def version
      FMOD.invoke(:System_GetVersion, self, version = "\0" * SIZEOF_INT)
      FMOD.uint2version(version)
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
    # all 100 sounds without any 'out of channels' errors, and swap the real
    # voices in and out according to which torches are closest in 3D space.
    # Priority for virtual channels can be changed in the sound's defaults, or
    # at runtime with {Channel.priority}.
    #
    # @param sound [Sound] The sound to play.
    # @param group [ChannelGroup] The {ChannelGroup} become a member of. This is
    #   more efficient than using {Channel.group}, as it does it during the
    #   channel setup, rather than connecting to the master channel group, then
    #   later disconnecting and connecting to the new {ChannelGroup} when
    #   specified. Specify +nil+ to ignore (use master {ChannelGroup}).
    # @param paused [Boolean] flag to specify whether to start the channel
    #   paused or not. Starting a channel paused allows the user to alter its
    #   attributes without it being audible, and un-pausing with
    #   ChannelControl.resume actually starts the sound.
    #
    # @return [Channel] the newly playing channel.
    def play_sound(sound, group = nil, paused = false)
      FMOD.type?(sound, Sound)
      channel = int_ptr
      FMOD.invoke(:System_PlaySound, self, sound, group, paused.to_i, channel)
      Channel.new(channel)
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
    # all 100 sounds without any 'out of channels' errors, and swap the real
    # voices in and out according to which torches are closest in 3D space.
    # Priority for virtual channels can be changed in the sound's defaults, or
    # at runtime with {Channel.priority}.
    #
    # @param dsp [Dsp] The DSP to play.
    # @param group [ChannelGroup] The {ChannelGroup} become a member of. This is
    #   more efficient than using {Channel.group}, as it does it during the
    #   channel setup, rather than connecting to the master channel group, then
    #   later disconnecting and connecting to the new {ChannelGroup} when
    #   specified. Specify +nil+ to ignore (use master {ChannelGroup}).
    # @param paused [Boolean] flag to specify whether to start the channel
    #   paused or not. Starting a channel paused allows the user to alter its
    #   attributes without it being audible, and un-pausing with
    #   ChannelControl.resume actually starts the sound.
    #
    # @return [Channel] the newly playing channel.
    def play_dsp(dsp, group = nil, paused = false)
      FMOD.type?(dsp, Dsp)
      channel = int_ptr
      FMOD.invoke(:System_PlayDSP, self, dsp, group, paused.to_i, channel)
      Channel.new(channel)
    end

    ##
    # Suspend mixer thread and relinquish usage of audio hardware while
    # maintaining internal state.
    #
    # @overload mixer_suspend
    #   When called with a block, automatically resumes the mixer when the block
    #   exits.
    #   @yield Yields control back to receiver.
    # @overload mixer_suspend
    #   When called without a block, user must call {#mixer_resume}.
    #
    # @return [void]
    # @see mixer_resume
    def mixer_suspend
      FMOD.invoke(:System_MixerSuspend, self)
      if block_given?
        yield
        FMOD.invoke(:System_MixerResume, self)
      end
    end

    ##
    # Resume mixer thread and reacquire access to audio hardware.
    # @return [void]
    # @see mixer_suspend
    def mixer_resume
      FMOD.invoke(:System_MixerResume, self)
    end

    ##
    # Retrieves the current reverb environment for the specified reverb
    # instance.
    #
    # @param index [Integer] Index of the particular reverb instance to target,
    #   from 0 to {FMOD::MAX_REVERB} inclusive.
    #
    # @return [Reverb] The specified Reverb instance.
    def [](index)
      reverb = Reverb.new
      FMOD.invoke(:System_GetReverbProperties, self, index, reverb)
      reverb
    end

    ##
    # Sets parameters for the global reverb environment.
    #
    # @param index [Integer] Index of the particular reverb instance to target,
    #   from 0 to {FMOD::MAX_REVERB} inclusive.
    # @param reverb [Reverb] A structure which defines the attributes for the
    #   reverb. Passing {FMOD::NULL} or +nil+ to this function will delete the
    #   physical reverb.
    #
    # @return [Reverb] the specified reverb.
    def []=(index, reverb)
      FMOD.type?(reverb, Reverb)
      FMOD.invoke(:System_SetReverbProperties, self, index, reverb)
    end

    alias_method :get_reverb, :[]
    alias_method :set_reverb, :[]=

    ##
    # @!attribute software_channels
    # @return [Integer] the maximum number of software mixed channels possible.
    integer_reader(:software_channels, :System_GetSoftwareChannels)
    integer_writer(:software_channels=, :System_SetSoftwareChannels, 0, 64)

    ##
    # @!attribute stream_buffer
    # @return [StreamBuffer] the internal buffer-size for streams.
    def stream_buffer
      size, type = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetStreamBufferSize, self, size, type)
      StreamBuffer.new(size.unpack1('L'), type.unpack1('l'))
    end

    def stream_buffer=(buffer)
      FMOD.type?(buffer, StreamBuffer)
      raise RangeError, "size must be greater than 0" unless buffer.size > 0
      FMOD.invoke(:System_SetStreamBufferSize, self, *buffer.values)
    end

    ##
    # @!attribute stream_buffer
    # @return [DspBuffer] the internal buffer-size for DSP units.
    def dsp_buffer
      size, count = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:System_GetDSPBufferSize, self, size, count)
      DspBuffer.new(size.unpack1('L'), count.unpack1('l'))
    end

    def dsp_buffer=(buffer)
      FMOD.type?(buffer, DspBuffer)
      raise RangeError, "size must be greater than 0" unless buffer.size > 0
      FMOD.invoke(:System_SetDSPBufferSize, self, *buffer.values)
    end

    ##
    # Updates the FMOD system. This should be called once per "game tick", or
    # once per frame in your application.
    #
    # @note Various callbacks are driven from this function, and it must be
    #   called for them to be invoked.
    #
    # @return [void]
    def update
      FMOD.invoke(:System_Update, self)
    end
  end
end


