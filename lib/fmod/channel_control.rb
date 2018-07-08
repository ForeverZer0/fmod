
module FMOD
  class ChannelControl < Handle

    ChannelDelay = Struct.new(:start, :end, :stop)

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

    float_reader(:low_pass_gain, :ChannelGroup_GetLowPassGain)
    float_writer(:low_pass_gain=, :ChannelGroup_SetLowPassGain, 0.0, 1.0)

































    float_reader(:level3D, :ChannelGroup_Get3DLevel)
    float_writer(:level3D=, :ChannelGroup_Set3DLevel, 0.0, 1.0)

    float_reader(:spread3D, :ChannelGroup_Get3DSpread)
    float_writer(:spread3D, :ChannelGroup_Set3DSpread, 0.0, 360.0)

    float_reader(:doppler3D, :ChannelGroup_Get3DDopplerLevel)
    float_writer(:doppler3D=, :ChannelGroup_Set3DDopplerLevel, 0.0, 5.0)

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
    def min_max_distance(min, max)
      FMOD.invoke(:ChannelGroup_Set3DMinMaxDistance, self, min, max)
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


    def pan(pan)
      FMOD.invoke(:ChannelGroup_SetPan, self, pan.clamp(-1.0, 1.0))
      self
    end

    def stop
      FMOD.invoke(:ChannelGroup_Stop, self)
      self
    end

    def pause
      FMOD.invoke(:ChannelGroup_SetPaused, self, 1)
      self
    end

    def resume
      FMOD.invoke(:ChannelGroup_SetPaused, self, 0)
      self
    end

    def mute
      FMOD.invoke(:ChannelGroup_SetMute, self, 1)
    end

    def unmute
      FMOD.invoke(:ChannelGroup_SetMute, self, 0)
    end

    def dsps
      DspChain.send(:new, self)
    end

    def parent
      FMOD.invoke(:ChannelGroup_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    def fade_ramp(clock, volume)
      FMOD.invoke(:ChannelGroup_SetFadePointRamp, self, clock, volume)
    end

    def dsp_clock
      buffer = "\0" * SIZEOF_LONG_LONG
      FMOD.invoke(:ChannelGroup_GetDSPClock, self, buffer, nil)
      buffer.unpack1('Q')
    end

    def parent_clock
      buffer = "\0" * SIZEOF_LONG_LONG
      FMOD.invoke(:ChannelGroup_GetDSPClock, self, nil, buffer)
      buffer.unpack1('Q')
    end

    def get_reverb_level(index)
      wet = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:ChannelGroup_GetReverbProperties, self, index, wet)
      wet.unpack1('f')
    end

    def set_reverb_level(index, wet_level)
      wet = wet_level.clamp(0.0, 1.0)
      FMOD.invoke(:ChannelGroup_SetReverbProperties, self, index, wet)
      wet
    end

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

    def set_delay(clock_start, clock_end, stop)
      stop = stop.to_i
      FMOD.invoke(:ChannelGroup_SetDelay, self, clock_start, clock_end, stop)
      self
    end

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
  end
end


