
module FMOD

  ##
  # @abstract
  # The base class for both {Channel} and {ChannelGroup} objects.
  class ChannelControl < Handle

    ##
    # Describes a volume point to fade from or towards, using a clock offset and
    # 0.0 to 1.0 volume level.
    #
    # @attr clock [Integer] DSP clock of the parent channel group to set the
    #   fade point volume.
    # @attr volume [Float] lume level where 0.0 is silent and 1.0 is normal
    #   volume. Amplification is supported.
    FadePoint = Struct.new(:clock, :volume)

    ##
    # Emulates an Array-type container of a {ChannelControl}'s DSP chain.
    class DspChain

      include Enumerable

      ##
      # Creates a new instance of a {DspChain} for the specified
      # {ChannelControl}.
      #
      # @param channel [ChannelControl] The channel or channel group to create
      #   the collection wrapper for.
      def initialize(channel)
        FMOD.type?(channel, ChannelControl)
        @channel = channel
      end

      ##
      # Retrieves the number of DSPs within the chain. This includes the
      # built-in {FMOD::Effects::Fader} DSP.
      # @return [Integer]
      def count
        buffer = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:ChannelGroup_GetNumDSPs, @channel, buffer)
        buffer.unpack1('l')
      end

      ##
      # @overload each(&block)
      #   If called with a block, passes each DSP in turn before returning self.
      #   @yield [dsp] Yields a DSP instance to the block.
      #   @yieldparam dsp [Dsp] The DSP instance.
      #   @return [self]
      # @overload each
      #   Returns an enumerator for the {DspChain} if no block is given.
      #   @return [Enumerator]
      def each
        return to_enum(:each) unless block_given?
        (0...count).each { |i| yield self[i] }
        self
      end

      ##
      # Element reference. Returns the element at index.
      # @param index [Integer] The index into the {DspChain} to retrieve.
      # @return [Dsp|nil] The DSP at the specified index, or +nil+ if index is
      #   out of range.
      def [](index)
        return nil unless index.between?(-2, count)
        dsp = "\0" * Fiddle::SIZEOF_INTPTR_T
        FMOD.invoke(:ChannelGroup_GetDSP, @channel, index, dsp)
        Dsp.from_handle(dsp)
      end

      ##
      # Element assignment. Sets the element at the specified index.
      # @param index [Integer] The index into the {DspChain} to set.
      # @param dsp [Dsp] A DSP instance.
      # @return [Dsp] The given DSP instance.
      def []=(index, dsp)
        FMOD.type?(dsp, Dsp)
        FMOD.invoke(:ChannelGroup_AddDSP, @channel, index, dsp)
        dsp
      end

      ##
      # Appends or pushes the given object(s) on to the end of this {DspChain}. This
      # expression returns +self+, so several appends may be chained together.
      # @param dsp [Dsp] One or more DSP instance(s).
      # @return [self]
      def add(*dsp)
        dsp.each { |d| self[DspIndex::TAIL] = d }
        self
      end

      ##
      # Prepends objects to the front of +self+, moving other elements upwards.
      # @param dsp [Dsp] A DSP instance.
      # @return [self]
      def unshift(dsp)
        self[DspIndex::HEAD] = dsp
        self
      end

      ##
      # Removes the last element from +self+ and returns it, or +nil+ if the
      # {DspChain} is empty.
      # @return [Dsp|nil]
      def pop
        dsp = self[DspIndex::TAIL]
        remove(dsp)
        dsp
      end

      ##
      # Returns the first element of +self+ and removes it (shifting all other
      # elements down by one). Returns +nil+ if the array is empty.
      # @return [Dsp|nil]
      def shift
        dsp = self[DspIndex::HEAD]
        remove(dsp)
        dsp
      end

      ##
      # Deletes the specified DSP from this DSP chain. This does not release ot
      # dispose the DSP unit, only removes from this {DspChain}, as a DSP unit
      # can be shared.
      # @param dsp [Dsp] The DSP to remove.
      # @return [self]
      def remove(dsp)
        return unless dsp.is_a?(Dsp)
        FMOD.invoke(:ChannelGroup_RemoveDSP, @channel, dsp)
        self
      end

      ##
      # Returns the index of the specified DSP.
      # @param dsp [Dsp] The DSP to retrieve the index of.
      # @return [Integer] The index of the DSP.
      def index(dsp)
        FMOD.type?(dsp, Dsp)
        buffer = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:ChannelGroup_GetDSPIndex, @channel, dsp, buffer)
        buffer.unpack1('l')
      end

      ##
      # Moves a DSP unit that exists in this {DspChain} to a new index.
      # @param dsp [Dsp] The DSP instance to move, must exist within this
      #   {DspChain}.
      # @param index [Integer] The new index to place the specified DSP.
      # @return [self]
      def move(dsp, index)
        FMOD.type?(dsp, Dsp)
        FMOD.invoke(:ChannelGroup_SetDSPIndex, @channel, dsp, index)
        self
      end

      alias_method :size, :count
      alias_method :length, :count
      alias_method :length, :count
      alias_method :delete, :remove
      alias_method :push, :add
      alias_method :<<, :add

      private_class_method :new
    end

    ##
    # Represents the start (and/or stop) time relative to the parent channel
    # group DSP clock, with sample accuracy.
    #
    # @attr start [Integer] The DSP clock of the parent channel group to audibly
    #   start playing sound at.
    # @attr end [Integer] The  DSP clock of the parent channel group to audibly
    #   stop playing sound at.
    # @attr stop [Boolean] +true+ to stop according to
    #   {ChannelControl.playing?}, otherwise +false+ to remain "active" and a
    #   new start delay could start playback again at a later time.
    ChannelDelay = Struct.new(:start, :end, :stop)

    ##
    # The settings for the 3D distance filter properties.
    #
    # @attr custom [Boolean] The enabled/disabled state of the FMOD distance
    #   rolloff calculation. Default is +false+.
    # @attr level [Float] The manual user attenuation, where 1.0 is no
    #   attenuation and 0.0 is complete attenuation. Default is 1.0.
    # @attr frequency [Float] The center frequency in Hz for the high-pass
    #   filter used to simulate distance attenuation, from 10.0 to 22050.0.
    #   Default is 1500.0.
    DistanceFilter = Struct.new(:custom, :level, :frequency)

    include Fiddle
    include FMOD::Core

    ##
    # @!attribute volume
    # Gets or sets the linear volume level.
    #
    # Volume level can be below 0.0 to invert a signal and above 1.0 to
    # amplify the signal. Note that increasing the signal level too far may
    # cause audible distortion.
    #
    # @return [Float]
    float_reader(:volume, :ChannelGroup_GetVolume)
    float_writer(:volume=, :ChannelGroup_SetVolume)

    ##
    # @!attribute volume_ramp
    # Gets or sets flag indicating whether the channel automatically ramps
    # when setting volumes.
    #
    # When changing volumes on a non-paused channel, FMOD normally adds a
    # small ramp to avoid a pop sound. This function allows that setting to be
    # overridden and volume changes to be applied immediately.
    #
    # @return [Boolean]
    bool_reader(:volume_ramp, :ChannelGroup_GetVolumeRamp)
    bool_writer(:volume_ramp=, :ChannelGroup_SetVolumeRamp)

    ##
    # @!attribute pitch
    # Sets the pitch value.
    #
    # This function scales existing frequency values by the pitch.
    # * *0.5:* One octave lower
    # * *2.0:* One octave higher
    # * *1.0:* Normal pitch
    # @return [Float]
    float_reader(:pitch, :ChannelGroup_GetPitch)
    float_writer(:pitch=, :ChannelGroup_SetPitch)

    ##
    # @!attribute mode
    # Changes some attributes for a {ChannelControl} based on the mode passed in.
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
    # * {Mode::VIRTUAL_PLAY_FROM_START}
    #
    # When changing the loop mode, sounds created with {Mode::CREATE_STREAM}
    # may have already been pre-buffered and executed their loop logic ahead
    # of time before this call was even made. This is dependant on the size of
    # the sound versus the size of the stream decode buffer. If this happens,
    # you may need to re-flush the stream buffer by calling {Channel.seek}.
    # Note this will usually only happen if you have sounds or loop points
    # that are smaller than the stream decode buffer size.
    #
    # @return [Integer] Mode bits.
    integer_reader(:mode, :ChannelGroup_GetMode)
    integer_writer(:mode=, :ChannelGroup_SetMode)

    ##
    # @!method playing?
    # @return [Boolean] the playing state.
    bool_reader(:playing?, :ChannelGroup_IsPlaying)

    ##
    # @!method paused?
    # @return [Boolean] the paused state.
    bool_reader(:paused?, :ChannelGroup_GetPaused)

    ##
    # @!method muted?
    # @return [Boolean] the mute state.
    bool_reader(:muted?, :ChannelGroup_GetMute)

    ##
    # @!attribute [r] audibility
    # The combined volume after 3D spatialization and geometry occlusion
    # calculations including any volumes set via the API.
    #
    # This does not represent the waveform, just the calculated result of all
    # volume modifiers. This value is used by the virtual channel system to
    # order its channels between real and virtual.
    #
    # @return [Float] the combined volume after 3D spatialization and geometry
    #   occlusion.
    float_reader(:audibility, :ChannelGroup_GetAudibility)

    # @!attribute low_pass_gain
    # The dry signal when low-pass filtering is applied.
    # * *Minimum:* 0.0 (silent, full filtering)
    # * *Maximum:* 1.0 (full volume, no filtering)
    # * *Default:* 1.0
    # @return [Float] the linear gain level.
    float_reader(:low_pass_gain, :ChannelGroup_GetLowPassGain)
    float_writer(:low_pass_gain=, :ChannelGroup_SetLowPassGain, 0.0, 1.0)

    # @!group 3D Sound

    ##
    # @!attribute level3D
    # The 3D pan level.
    # * *Minimum:* 0.0 (attenuation is ignored and panning as set by 2D panning
    #   functions)
    # * *Maximum:* 1.0 (pan and attenuate according to 3D position)
    # * *Default:* 0.0
    # @return [Float] the 3D pan level.
    float_reader(:level3D, :ChannelGroup_Get3DLevel)
    float_writer(:level3D=, :ChannelGroup_Set3DLevel, 0.0, 1.0)

    ##
    # @!attribute spread3D
    # The speaker spread angle.
    # * *Minimum:* 0.0
    # * *Maximum:* 360.0
    # * *Default:* 0.0
    # @return [Float] the spread of a 3D sound in speaker space.
    float_reader(:spread3D, :ChannelGroup_Get3DSpread)
    float_writer(:spread3D, :ChannelGroup_Set3DSpread, 0.0, 360.0)

    ##
    # @!attribute doppler3D
    # The doppler scale.
    # * *Minimum:* 0.0 (none)
    # * *Maximum:* 5.0 (exaggerated)
    # * *Default:* 1.0 (normal)
    # @return [Float] the amount by which doppler is scaled.
    float_reader(:doppler3D, :ChannelGroup_Get3DDopplerLevel)
    float_writer(:doppler3D=, :ChannelGroup_Set3DDopplerLevel, 0.0, 5.0)

    ##
    # @!attribute direct_occlusion
    # @return [Float] the occlusion factor for the direct path.

    def direct_occlusion
      direct = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:ChannelGroup_Get3DOcclusion, self, direct, nil)
      direct.unpack1('f')
    end

    def direct_occlusion=(direct)
      direct = direct.clamp(0.0, 1.0)
      reverb = reverb_occlusion
      FMOD.invoke(:ChannelGroup_Set3DOcclusion, self, direct, reverb)
      direct
    end

    ##
    # @!attribute reverb_occlusion
    # @return [Float] the occlusion factor for the reverb mix.

    def reverb_occlusion
      reverb = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:ChannelGroup_Get3DOcclusion, self, nil, reverb)
      reverb.unpack1('f')
    end

    def reverb_occlusion=(reverb)
      direct = direct_occlusion
      reverb = reverb.clamp(0.0, 1.0)
      FMOD.invoke(:ChannelGroup_Set3DOcclusion, self, direct, reverb)
      reverb
    end

    ##
    # @!attribute position3D
    # @return [Vector] the position used to apply panning, attenuation and
    #   doppler.

    def position3D
      position = Vector.zero
      FMOD.invoke(:ChannelGroup_Get3DAttributes, self, position, nil, nil)
      position
    end

    def position3D=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:ChannelGroup_Set3DAttributes, self, vector, nil, nil)
      vector
    end

    ##
    # @!attribute velocity3D
    # @return [Vector] the velocity used to apply panning, attenuation and
    #   doppler.

    def velocity3D
      velocity = Vector.zero
      FMOD.invoke(:ChannelGroup_Get3DAttributes, self, nil, velocity, nil)
      velocity
    end

    def velocity3D=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:ChannelGroup_Set3DAttributes, self, nil, vector, nil)
      vector
    end

    ##
    # @!attribute distance_filter
    # @return [DistanceFilter] the behaviour of a 3D distance filter, whether to
    #   enable or disable it, and frequency characteristics.
    def distance_filter
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:ChannelGroup_Get3DDistanceFilter, self, *args)
      args = args.join.unpack('lff')
      args[0] = args[0] != 0
      DistanceFilter.new(*args)
    end

    def distance_filter=(filter)
      FMOD.type?(filter, DistanceFilter)
      args = filter.values
      args[0] = args[0].to_i
      FMOD.invoke(:ChannelGroup_Set3DDistanceFilter, self, *args)
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
      FMOD.invoke(:ChannelGroup_Get3DCustomRolloff, self, nil, count)
      count = count.unpack1('l')
      return [] if count.zero?
      size = SIZEOF_FLOAT * 3
      FMOD.invoke(:ChannelGroup_Get3DCustomRolloff, self, ptr = int_ptr, nil)
      buffer = Pointer.new(ptr.unpack1('J'), count * size).to_str
      (0...count).map { |i| Vector.new(*buffer[i * size, size].unpack('fff')) }
    end

    def custom_rolloff=(rolloff)
      FMOD.type?(rolloff, Array)
      vectors = rolloff.map { |vector| vector.to_str }.join
      FMOD.invoke(:ChannelGroup_Set3DCustomRolloff, self, vectors, rolloff.size)
      rolloff
    end

    ##
    # @!attribute min_distance
    # @return [Float] Minimum volume distance in "units". (Default: 1.0)
    # @see max_distance
    # @see min_max_distance

    def min_distance
      min = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:ChannelGroup_Get3DMinMaxDistance, self, min, nil)
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
      FMOD.invoke(:ChannelGroup_Get3DMinMaxDistance, self, nil, max)
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
      FMOD.invoke(:ChannelGroup_Set3DMinMaxDistance, self, min, max)
    end

    ##
    # @!attribute cone_orientation
    # @return [Vector] the orientation of the sound projection cone.

    def cone_orientation
      vector = FMOD::Core::Vector.new
      FMOD.invoke(:ChannelGroup_Get3DConeOrientation, self, vector)
      vector
    end

    def cone_orientation=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:ChannelGroup_Set3DConeOrientation, self, vector)
      vector
    end

    ##
    # @!attribute cone_settings
    # The angles that define the sound projection cone including the volume when
    # outside the cone.
    # @since 0.9.2
    # @return [ConeSettings] the sound projection cone.
    def cone_settings
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:ChannelGroup_Get3DConeSettings, self, *args)
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
    # @since 0.9.2
    # @return [void]
    def set_cone(inside_angle, outside_angle, outside_volume)
      if outside_angle < inside_angle
        raise Error, 'Outside angle must be greater than inside angle.'
      end
      FMOD.invoke(:ChaennlGroup_Set3DConeSettings, self, inside_angle,
                  outside_angle, outside_volume)
      self
    end

    # @!endgroup

    ##
    # Add a volume point to fade from or towards, using a clock offset and 0.0
    # to 1.0 volume level.
    # @overload add_fade(fade_point)
    #   @param fade_point [FadePoint] Fade point structure defining the values.
    # @overload add_fade(clock, volume)
    #   @param clock [Integer] DSP clock of the parent channel group to set the
    #     fade point volume.
    #   @param volume [Float] Volume level where 0.0 is silent and 1.0 is normal
    #     volume. Amplification is supported.
    # @return [self]
    def add_fade(*args)
      args = args[0].values if args.size == 1 && args[0].is_a?(FadePoint)
      FMOD.invoke(:ChannelGroup_AddFadePoint, self, *args)
      self
    end

    ##
    # Retrieves the number of fade points set within the {ChannelControl}.
    # @return [Integer] The number of fade points.
    def fade_point_count
      count = "\0" * SIZEOF_INT
      FMOD.invoke(:ChannelGroup_GetFadePoints, self, count, nil, nil)
      count.unpack1('l')
    end

    ##
    # Retrieve information about fade points stored within a {ChannelControl}.
    # @return [Array<FadePoint>] An array of {FadePoint} objects, or an empty
    #   array if no fade points are present.
    def fade_points
      count = fade_point_count
      return [] if count.zero?
      clocks = "\0" * (count * SIZEOF_LONG_LONG)
      volumes = "\0" * (count * SIZEOF_FLOAT)
      FMOD.invoke(:ChannelGroup_GetFadePoints, self, int_ptr, clocks, volumes)
      args = clocks.unpack('Q*').zip(volumes.unpack('f*'))
      args.map { |values| FadePoint.new(*values) }
    end

    ##
    # Remove volume fade points on the time-line. This function will remove
    # multiple fade points with a single call if the points lay between the 2
    # specified clock values (inclusive).
    # @param clock_start [Integer] DSP clock of the parent channel group to
    #   start removing fade points from.
    # @param clock_end [Integer] DSP clock of the parent channel group to start
    #   removing fade points to.
    # @return [self]
    def remove_fade_points(clock_start, clock_end)
      FMOD.invoke(:ChannelGroup_RemoveFadePoints, self, clock_start, clock_end)
      self
    end

    ##
    # Sets the speaker volume levels for each speaker individually, this is a
    # helper to avoid having to set the mix matrix.
    #
    # Levels can be below 0 to invert a signal and above 1 to amplify the
    # signal. Note that increasing the signal level too far may cause audible
    # distortion. Speakers specified that don't exist will simply be ignored.
    # For more advanced speaker control, including sending the different
    # channels of a stereo sound to arbitrary speakers, see {#matrix}.
    #
    # @note This function overwrites any pan/mix-level by overwriting the
    # {ChannelControl}'s matrix.
    #
    # @param fl [Float] Volume level for the front left speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param fr [Float] Volume level for the front right speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param center [Float] Volume level for the center speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param lfe [Float] Volume level for the sub-woofer speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param sl [Float] Volume level for the surround left speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param sr [Float] Volume level for the surround right speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param bl [Float] Volume level for the back left speaker of a multichannel
    #   speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @param br [Float] Volume level for the back right speaker of a
    #   multichannel speaker setup, 0.0 (silent), 1.0 (normal volume).
    # @return [self]
    def output_mix(fl, fr, center, lfe, sl, sr, bl, br)
      FMOD.invoke(:ChannelGroup_SetMixLevelsOutput, self, fl,
        fr, center, lfe, sl, sr, bl, br)
      self
    end

    ##
    # Sets the incoming volume level for each channel of a multi-channel sound.
    # This is a helper to avoid calling {#matrix}.
    #
    # A multi-channel sound is a single sound that contains from 1 to 32
    # channels of sound data, in an interleaved fashion. If in the extreme case,
    # a 32 channel wave file was used, an array of 32 floating point numbers
    # denoting their volume levels would be passed in to the levels parameter.
    #
    # @param levels [Array<Float>] Array of volume levels for each incoming
    #   channel.
    # @return [self]
    def input_mix(*levels)
      count = levels.size
      binary = levels.pack('f*')
      FMOD.invoke(:ChannelGroup_SetMixLevelsInput, self, binary, count)
      self
    end

    ##
    # @!attribute matrix
    # A 2D pan matrix that maps input channels (columns) to output speakers
    # (rows).
    #
    # Levels can be below 0 to invert a signal and above 1 to amplify the
    # signal. Note that increasing the signal level too far may cause audible
    # distortion.
    #
    # The matrix size will generally be the size of the number of channels in
    # the current speaker mode. Use {System.software_format }to determine this.
    #
    # If a matrix already exists then the matrix passed in will applied over the
    # top of it. The input matrix can be smaller than the existing matrix.
    #
    # A "unit" matrix allows a signal to pass through unchanged. For example for
    # a 5.1 matrix a unit matrix would look like this:
    #   [[ 1, 0, 0, 0, 0, 0 ]
    #    [ 0, 1, 0, 0, 0, 0 ]
    #    [ 0, 0, 1, 0, 0, 0 ]
    #    [ 0, 0, 0, 1, 0, 0 ]
    #    [ 0, 0, 0, 0, 1, 0 ]
    #    [ 0, 0, 0, 0, 0, 1 ]]
    #
    # @return [Array<Array<Float>>] a 2-dimensional array of volume levels in
    #   row-major order. Each row represents an output speaker, each column
    #   represents an input channel.
    def matrix
      o, i = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:ChannelGroup_GetMixMatrix, self, nil, o, i, 0)
      o, i = o.unpack1('l'), i.unpack1('l')
      return [] if o.zero? || i.zero?
      buffer = "\0" * (SIZEOF_FLOAT * o * i)
      FMOD.invoke(:ChannelGroup_GetMixMatrix, self, buffer, int_ptr, int_ptr, 0)
      buffer.unpack('f*').each_slice(i).to_a
    end

    def matrix=(matrix)
      out_count, in_count = matrix.size, matrix.first.size
      unless matrix.all? { |ary| ary.size == in_count }
        raise Error, "Matrix contains unequal length input channels."
      end
      data = matrix.flatten.pack('f*')
      FMOD.invoke(:ChannelGroup_SetMixMatrix, self, data,
        out_count, in_count, 0)
    end

    ##
    # Sets the pan level, this is a helper to avoid setting the {#matrix}.
    #
    # Mono sounds are panned from left to right using constant power panning
    # (non-linear fade). This means when pan = 0.0, the balance for the sound in
    # each speaker is 71% left and 71% right, not 50% left and 50% right. This
    # gives (audibly) smoother pans.
    #
    # Stereo sounds heave each left/right value faded up and down according to
    # the specified pan position. This means when pan is 0.0, the balance for
    # the sound in each speaker is 100% left and 100% right. When pan is -1.0,
    # only the left channel of the stereo sound is audible, when pan is 1.0,
    # only the right channel of the stereo sound is audible.
    #
    # @param pan [Float] The desired pan level.
    #   * *Minimum:* -1.0 (left)
    #   * *Maximum:* 1.0 (right)
    #   * *Default:* 0.0 (center)
    #
    # @return [self]
    def pan(pan)
      FMOD.invoke(:ChannelGroup_SetPan, self, pan.clamp(-1.0, 1.0))
      self
    end

    ##
    # Stops the channel (or all channels in the channel group) from playing.
    #
    # Makes it available for re-use by the priority system.
    #
    # @return [void]
    def stop
      FMOD.invoke(:ChannelGroup_Stop, self)
    end

    ##
    # Sets the paused state.
    #
    # @return [self]
    # @see resume
    # @see paused?
    def pause
      FMOD.invoke(:ChannelGroup_SetPaused, self, 1)
      self
    end

    ##
    # Resumes playback from a paused state.
    #
    # @return [self]
    # @see pause
    # @see paused?
    def resume
      FMOD.invoke(:ChannelGroup_SetPaused, self, 0)
      self
    end

    ##
    # Sets the mute state effectively silencing it or returning it to its normal
    # volume.
    #
    # @return [self]
    # @see unmute
    # @see muted?
    def mute
      FMOD.invoke(:ChannelGroup_SetMute, self, 1)
      self
    end

    ##
    # Resumes the volume from a muted state.
    #
    # @return [self]
    # @see mute
    # @see muted?
    def unmute
      FMOD.invoke(:ChannelGroup_SetMute, self, 0)
      self
    end

    ##
    # @!attribute dsps
    # @return [DspChain] the DSP chain of the {ChannelControl}, containing the
    #   effects currently applied.
    def dsps
      DspChain.send(:new, self)
    end

    ##
    # @!attribute [r] parent
    # @return [System] the parent {System} object that was used to create this
    #   object.
    def parent
      FMOD.invoke(:ChannelGroup_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    ##
    # Add a short 64 sample volume ramp to the specified time in the future
    # using fade points.
    #
    # @param clock [Integer] DSP clock of the parent channel group when the
    #   volume will be ramped to.
    # @param volume [Float] Volume level where 0 is silent and 1.0 is normal
    #   volume. Amplification is supported.
    #
    # @return [void]
    def fade_ramp(clock, volume)
      FMOD.invoke(:ChannelGroup_SetFadePointRamp, self, clock, volume)
    end

    ##
    # Retrieves the DSP clock value which count up by the number of samples per
    # second in the software mixer, i.e. if the default sample rate is 48KHz,
    # the DSP clock increments by 48000 per second.
    #
    # @return [Integer] the current clock value.
    def dsp_clock
      buffer = "\0" * SIZEOF_LONG_LONG
      FMOD.invoke(:ChannelGroup_GetDSPClock, self, buffer, nil)
      buffer.unpack1('Q')
    end

    ##
    # Retrieves the DSP clock value which count up by the number of samples per
    # second in the software mixer, i.e. if the default sample rate is 48KHz,
    # the DSP clock increments by 48000 per second.
    #
    # @return [Integer] the current parent clock value.
    def parent_clock
      buffer = "\0" * SIZEOF_LONG_LONG
      FMOD.invoke(:ChannelGroup_GetDSPClock, self, nil, buffer)
      buffer.unpack1('Q')
    end

    ##
    # Retrieves the wet level (or send level) for a particular reverb instance.
    #
    # @param index [Integer] Index of the particular reverb instance to target.
    #
    # @return [Float] the send level for the signal to the reverb, from 0 (none)
    #   to 1.0 (full).
    # @see set_reverb_level
    def get_reverb_level(index)
      wet = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:ChannelGroup_GetReverbProperties, self, index, wet)
      wet.unpack1('f')
    end

    ##
    # Sets the wet level (or send level) of a particular reverb instance.
    #
    # A Channel is automatically connected to all existing reverb instances due
    # to the default wet level of 1.0. A ChannelGroup however will not send to
    # any reverb by default requiring an explicit call to this function.
    #
    # A ChannelGroup reverb is optimal for the case where you want to send 1
    # mixed signal to the reverb, rather than a lot of individual channel reverb
    # sends. It is advisable to do this to reduce CPU if you have many Channels
    # inside a ChannelGroup.
    #
    # Keep in mind when setting a wet level for a ChannelGroup, any Channels
    # under that ChannelGroup will still have their existing sends to the
    # reverb. To avoid this doubling up you should explicitly set the Channel
    # wet levels to 0.0.
    #
    # @param index [Integer] Index of the particular reverb instance to target.
    #
    # @return [void]
    # @see get_reverb_level
    def set_reverb_level(index, wet_level)
      wet = wet_level.clamp(0.0, 1.0)
      FMOD.invoke(:ChannelGroup_SetReverbProperties, self, index, wet)
    end

    ##
    # @!attribute delay
    # The start (and/or stop) time relative to the parent channel group DSP
    # clock, with sample accuracy.
    #
    # Every channel and channel group has its own DSP Clock. A channel or
    # channel group can be delayed relatively against its parent, with sample
    # accurate positioning. To delay a sound, use the 'parent' channel group DSP
    # clock to reference against when passing values into this function.
    #
    # If a parent channel group changes its pitch, the start and stop times will
    # still be correct as the parent clock is rate adjusted by that pitch.
    #
    # @return [ChannelDelay] the delay.
    # @see set_delay

    def delay
      clock_start = "\0" * SIZEOF_LONG_LONG
      clock_end = "\0" * SIZEOF_LONG_LONG
      stop = "\0" * SIZEOF_INT
      FMOD.invoke(:ChannelGroup_GetDelay, self, clock_start, clock_end, stop)
      stop = stop.unpack1('l') != 0
      ChannelDelay.new(clock_start.unpack1('Q'), clock_end.unpack1('Q'), stop)
    end

    def delay=(delay)
      FMOD.type?(delay, ChannelDelay)
      set_delay(delay.start, delay.end, delay.stop)
      delay
    end

    ##
    # The start (and/or stop) time relative to the parent channel group DSP
    # clock, with sample accuracy.
    #
    # Every channel and channel group has its own DSP Clock. A channel or
    # channel group can be delayed relatively against its parent, with sample
    # accurate positioning. To delay a sound, use the 'parent' channel group DSP
    # clock to reference against when passing values into this function.
    #
    # If a parent channel group changes its pitch, the start and stop times will
    # still be correct as the parent clock is rate adjusted by that pitch.
    #
    # @param clock_start [Integer] DSP clock of the parent channel group to
    #   audibly start playing sound at, a value of 0 indicates no delay.
    # @param clock_end [Integer] DSP clock of the parent channel group to
    #   audibly stop playing sound at, a value of 0 indicates no delay.
    # @param stop [Boolean] +true+ to stop according to {#playing?}, otherwise
    #   +false+ to remain "active" and a new start delay could start playback
    #   again at a later time.
    #
    # @return [self]
    # @see delay
    def set_delay(clock_start, clock_end, stop)
      stop = stop.to_i
      FMOD.invoke(:ChannelGroup_SetDelay, self, clock_start, clock_end, stop)
      self
    end

    # @!group Callbacks

    ##
    # Binds the given block so that it will be invoked when the channel is
    # stopped, either by {#stop} or when playback reaches an end.
    # @example
    #   >> channel.on_stop do
    #   >>   puts "Channel stop"
    #   >> end
    #   >> channel.stop
    #
    #   "Channel stop"
    # @param proc [Proc] Proc to call. Optional, must give block if nil.
    # @yield The block to call when the {ChannelControl} is stopped.
    # @yieldreturn [Channel] The {ChannelControl} receiving this callback.
    # @return [self]
    def on_stop(proc = nil, &block)
      set_callback(0, &(block_given? ? block : proc))
    end

    ##
    # Binds the given block so that it will be invoked when the a voice is
    # swapped to or from emulated/real.
    # @param proc [Proc] Proc to call. Optional, must give block if nil.
    # @yield [emulated] The block to call when a voice is swapped, with flag
    #   indicating if voice is emulated passed to it.
    # @yieldparam emulated [Boolean]
    #   * *true:* Swapped from real to emulated
    #   * *false:* Swapped from emulated to real
    # @yieldreturn [Channel] The {ChannelControl} receiving this callback.
    # @return [self]
    def on_voice_swap(proc = nil, &block)
      set_callback(1, &(block_given? ? block : proc))
    end

    ##
    # Binds the given block so that it will be invoked when a sync-point is
    # encountered.
    # @param proc [Proc] Proc to call. Optional, must give block if nil.
    # @yield [index] The block to call when a sync-point is encountered, with
    #   the index of the sync-point passed to it.
    # @yieldparam index [Integer] The sync-point index.
    # @yieldreturn [Channel] The {ChannelControl} receiving this callback.
    # @return [self]
    def on_sync_point(proc = nil, &block)
      set_callback(2, &(block_given? ? block : proc))
    end

    ##
    # Binds the given block so that it will be invoked when the occlusion is
    # calculated.
    # @param proc [Proc] Proc to call. Optional, must give block if nil.
    # @yield [direct, reverb] The block to call when occlusion is calculated,
    #   with pointers to the direct and reverb occlusion values passed to it.
    # @yieldparam direct [Pointer] A pointer to a floating point direct value
    #   that can be read (de-referenced) and modified after the geometry engine
    #   has calculated it for this channel.
    # @yieldparam reverb [Pointer] A pointer to a floating point reverb value
    #   that can be read (de-referenced) and modified after the geometry engine
    #   has calculated it for this channel.
    # @yieldreturn [Channel] The {ChannelControl} receiving this callback.
    # @return [self]
    def on_occlusion(proc = nil, &block)
      set_callback(3, &(block_given? ? block : proc))
    end

    # @!endgroup

    ##
    # @api private
    def initialize(address = nil)
      super
      @callbacks = {}
      ret = TYPE_INT
      sig = [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP]
      abi = FMOD::ABI
      bc = Closure::BlockCaller.new(ret, sig, abi) do |_c, _t, cb_type, d1, d2|
        if @callbacks[cb_type]
          case cb_type
          when 0 then @callbacks[0].each(&:call)
          when 1
            virtual = d1.to_s(SIZEOF_INT).unpack1('l') != 0
            @callbacks[1].each { |cb| cb.call(virtual) }
          when 2
            index = d1.to_s(SIZEOF_INT).unpack1('l')
            @callbacks[2].each { |cb| cb.call(index) }
          when 3 then @callbacks[3].each { |cb| cb.call(d1, d2) }
          else raise FMOD::Error, "Invalid channel callback type."
          end
        end
        Result::OK
      end
      FMOD.invoke(:ChannelGroup_SetCallback, self, bc)
    end

    private

    def set_callback(index, &block)
      raise LocalJumpError, "No block given." unless block_given?
      @callbacks[index] ||= []
      @callbacks[index] << block
      self
    end
  end
end


