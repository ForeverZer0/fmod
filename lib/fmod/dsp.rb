



module FMOD

  ##
  # Represents a digital signal processor. This allows for monitoring and
  # applying effects to the sound in real-time.
  class Dsp < Handle

    ##
    # Describes mix levels that allow the user to scale the affect of a DSP
    # effect, through control of the "wet" mix, which is the post-processed
    # signal and the "dry" which is the pre-processed signal.
    #
    # @attr pre_wet [Float] A floating point value from 0.0 to 1.0, describing a
    #   linear scale of the "wet" (pre-processed signal) mix of the effect.
    #   Default is 1.0. Scale can be lower than 0.0 (negating) and higher than
    #   1.0 (amplifying).
    # @attr post_wet [Float] A floating point value from 0.0 to 1.0, describing
    #   a linear scale of the "'wet' "(post-processed signal) mix of the effect.
    #   Default is 1.0. Scale can be lower than 0.0 (negating) and higher than
    #   1.0 (amplifying).
    # @attr dry [Float] A floating point value from 0.0 to 1.0, describing a
    #   linear scale of the "dry" (pre-processed signal) mix of the effect.
    #   Default is 0.0. Scale can be lower than 0.0 and higher than 1.0
    #   (amplifying).
    WetDryMix = Struct.new(:pre_wet, :post_wet, :dry)

    ##
    #  Defines the signal format of a dsp unit so that the signal is processed
    #  on the speakers specified, as well as the number of channels in the unit
    #  that a read callback will process, and the output signal of the unit.
    #
    # Setting the number of channels on a unit will force a down or up mix to
    # that channel count before processing the DSP read callback. This count is
    # then sent to the outputs of the unit.
    #
    # The speaker mode is informational, when the mask describes what bits are
    # active, and the channel count describes how many channels are in a buffer,
    # speaker mode describes where the channels originated from. For example if
    # the channel count is 2 then this could describe for the DSP if the
    # original signal started from a stereo signal or a 5.1 signal.
    #
    # It could also describe the signal as all monaural, for example if the
    # channel count was 16 and the speaker mode was {SpeakerMode::MONO}.
    #
    # @attr mask [Integer] A series of bits specified by {ChannelMask} to
    #   determine which speakers are represented by the channels in the signal.
    # @attr count [Integer] The number of channels to be processed on this unit
    #   and sent to the outputs connected to it. Maximum of
    #   {FMOD::MAX_CHANNEL_WIDTH}.
    # @attr speaker_mode [Integer] The source speaker mode where the signal came
    #   from.
    #
    # @see ChannelMask
    # @see SpeakerMode
    ChannelFormat = Struct.new(:mask, :count, :speaker_mode)

    ##
    # Contains information about the current DSP unit, including name, version,
    # default channels and width and height of configuration dialog box if it
    # exists.
    #
    # @attr name [String] The name of the unit.
    # @attr version [String] The version number of the DSP unit.
    # @attr channels [Integer] The number of channels the unit was initialized
    #   with. 0 means the plugin will process whatever number of channels is
    #   currently in the network. >0 would be mostly used if the unit is a unit
    #   that only generates sound, or is not flexible enough to take any number
    #   of input channels.
    # @attr width [Integer] The width of an optional configuration dialog box
    #   that can be displayed with {Dsp.show_dialog}. 0 means the dialog is not
    #   present.
    # @attr height [Integer] The height of an optional configuration dialog box
    #   that can be displayed with {Dsp.show_dialog}. 0 means the dialog is not
    #   present.
    DspInfo = Struct.new(:name, :version, :channels, :width, :height) do

      # @!method config?
      # @return [Boolean] a flag indicating if DSP unit has an optional
      #   configuration dialog that can be displayed.
      # @note None of the built-in DSP units contain a dialog.
      def config?
        width > 0 && height > 0
      end
    end

    ##
    # Retrieves a hash mapping the class of each DSP to its corresponding
    # integer type defined in {DspType}.
    # @return [Hash{Integer=>Class}]
    def self.type_map(type)
      @type_map ||= {
        DspType::MIXER => FMOD::Effects::Mixer,
        DspType::OSCILLATOR => FMOD::Effects::Oscillator,
        DspType::LOW_PASS => FMOD::Effects::LowPass,
        DspType::IT_LOW_PASS => FMOD::Effects::ITLowPass,
        DspType::HIGH_PASS => FMOD::Effects::HighPass,
        DspType::ECHO => FMOD::Effects::Echo,
        DspType::FADER => FMOD::Effects::Fader,
        DspType::FLANGE => FMOD::Effects::Flange,
        DspType::DISTORTION => FMOD::Effects::Distortion,
        DspType::NORMALIZE => FMOD::Effects::Normalize,
        DspType::LIMITER => FMOD::Effects::Limiter,
        DspType::PARAM_EQ => FMOD::Effects::ParamEq,
        DspType::PITCH_SHIFT => FMOD::Effects::PitchShift,
        DspType::CHORUS => FMOD::Effects::Chorus,
        DspType::VST_PLUGIN => FMOD::Effects::VstPlugin,
        DspType::WINAMP_PLUGIN => FMOD::Effects::WinampPlugin,
        DspType::IT_ECHO => FMOD::Effects::ITEcho,
        DspType::COMPRESSOR => FMOD::Effects::Compressor,
        DspType::SFX_REVERB => FMOD::Effects::SfxReverb,
        DspType::LOW_PASS_SIMPLE => FMOD::Effects::LowPassSimple,
        DspType::DELAY => FMOD::Effects::Delay,
        DspType::TREMOLO => FMOD::Effects::Tremolo,
        DspType::LADSPA_PLUGIN => FMOD::Effects::LadspaPlugin,
        DspType::SEND => FMOD::Effects::Send,
        DspType::RETURN => FMOD::Effects::Return,
        DspType::HIGH_PASS_SIMPLE => FMOD::Effects::HighPassSimple,
        DspType::PAN => FMOD::Effects::Pan,
        DspType::THREE_EQ => FMOD::Effects::ThreeEq,
        DspType::FFT => FMOD::Effects::FFT,
        DspType::LOUDNESS_METER => FMOD::Effects::LoudnessMeter,
        DspType::ENVELOPE_FOLLOWER => FMOD::Effects::EnvelopeFollower,
        DspType::CONVOLUTION_REVERB => FMOD::Effects::ConvolutionReverb,
        DspType::CHANNEL_MIX => FMOD::Effects::ChannelMix,
        DspType::TRANSCEIVER => FMOD::Effects::Transceiver,
        DspType::OBJECT_PAN => FMOD::Effects::ObjectPan,
        DspType::MULTIBAND_EQ => FMOD::Effects::MultibandEq
      }
      return @type_map[type] if type.is_a?(Integer)
      return @type_map.key(type) if type.is_a?(Class)
      raise TypeError, "#{type} is not a Integer or Class."
    end

    ##
    # Plays a sound object on a particular channel and {ChannelGroup}.
    #
    # When a sound is played, it will use the sound's default frequency and
    # priority.
    #
    # @param group [ChannelGroup] The {ChannelGroup} become a member of. This is
    #   more efficient than using {Channel.group}, as it does it during the
    #   channel setup, rather than connecting to the master channel group, then
    #   later disconnecting and connecting to the new {ChannelGroup} when
    #   specified. Specify +nil+ to ignore (use master {ChannelGroup}).
    #
    # @return [Channel] the newly playing channel.
    # @see System.play_dsp
    def play(group = nil)
      parent.play_dsp(self, group, false)
    end

    ##
    # Converts the specified memory address to a DSP of the appropriate
    # sub-type instead of generic {Dsp} type.
    # @param address [Integer|String|Pointer] The memory address of the DSP.
    # @return [Dsp] A DSP class found in {FMOD::Effects}.
    def self.from_handle(address)
      address = address.unpack1('J') if address.is_a?(String)
      type = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetType, address.to_i, type)
      klass = type_map(type.unpack1('l')) rescue Dsp
      klass.new(address)
    end

    ##
    # @!attribute [r] type
    # Retrieves the pre-defined type of a FMOD registered DSP unit.
    #
    # @return [Integer]
    # @see DspType
    integer_reader(:type, :DSP_GetType)

    ##
    # @!attribute [r] parameter_count
    # Retrieves the number of parameters a DSP unit has to control its
    # behavior.
    #
    # @return [Integer]
    integer_reader(:parameter_count, :DSP_GetNumParameters)

    ##
    # @!attribute [r] input_count
    # Retrieves the number of inputs connected to the DSP unit.
    #
    # Inputs are units that feed data to this unit. When there are multiple
    # inputs, they are mixed together.
    #
    # @note Because this function needs to flush the DSP queue before it can
    #   determine how many units are available, this function may block
    #   significantly while the background mixer thread operates.
    # @return [Integer]
    integer_reader(:input_count, :DSP_GetNumInputs)

    ##
    # @!attribute [r] output_count
    # Retrieves the number of outputs connected to the DSP unit.
    #
    # Outputs are units that this unit feeds data to. When there are multiple
    # outputs, the data is split and sent to each unit individually.
    #
    # @note Because this function needs to flush the DSP queue before it can
    #   determine how many units are available, this function may block
    #   significantly while the background mixer thread operates.
    #
    # @return [Integer]
    integer_reader(:output_count, :DSP_GetNumOutputs)

    ##
    # @!method idle?
    # Retrieves the idle state of a DSP. A DSP is idle when no signal is
    # coming into it. This can be a useful method of determining if a DSP sub
    # branch is finished processing, so it can be disconnected for example.
    #
    # @return [Boolean]
    bool_reader(:idle?, :DSP_GetIdle)

    ##
    # @!attribute active
    # Gets or sets the enabled state of a unit for being processed.
    #
    # This does not connect or disconnect a unit in any way, it just disables
    # it so that it is not processed.
    #
    # If a unit is disabled, and has inputs, they will also cease to be
    # processed.
    #
    # To disable a unit but allow the inputs of the unit to continue being
    # processed, use {#bypass} instead.
    #
    # @return [Boolean]
    bool_reader(:active, :DSP_GetActive)
    bool_writer(:active=, :DSP_SetActive)

    ##
    # @!attribute bypass
    # Enables or disables the read callback of a DSP unit so that it does or
    # doesn't process the data coming into it.
    #
    # A DSP unit that is disabled still processes its inputs, it will just be
    # "dry".
    #
    # If a unit is bypassed, it will still process its inputs.
    #
    # To disable the unit and all of its inputs, use {#active} instead.
    # @return [Boolean]
    bool_reader(:bypass, :DSP_GetBypass)
    bool_writer(:bypass=, :DSP_SetBypass)

    ##
    # Retrieves the name of this DSP unit.
    # @return [String]
    def name
      name = "\0" * 32
      FMOD.invoke(:DSP_GetInfo, self, name, nil, nil, nil, nil)
      name.delete("\0")
    end

    ##
    # Retrieves the version of this DSP as string.
    # @return [String]
    def version
      vs = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetInfo, self, nil, vs, nil, nil, nil)
      version = vs.unpack1('L').to_s(16).rjust(8, '0')
      "#{version[0, 4].to_i}.#{version[4, 4].to_i}"
    end

    # @attribute wet_dry_mix
    # Allows the user to scale the affect of a DSP effect, through control of
    # the "wet" mix, which is the post-processed signal and the "dry" which is
    # the pre-processed signal.
    #
    # The dry signal path is silent by default, because DSP effects transform
    # the input and pass the newly processed result to the output. It does not
    # add to the input.
    #
    # @return [WetDryMix] the current mix.
    # @see WetDryMix
    def wet_dry_mix
      args = ["\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT, "\0" * SIZEOF_FLOAT]
      FMOD.invoke(:DSP_GetWetDryMix, self, *args)
      args.map! { |arg| arg.unpack1('f') }
      WetDryMix.new(*args)
    end

    def wet_dry_mix=(mix)
      FMOD.type?(mix, WetDryMix)
      FMOD.invoke(:DSP_SetWetDryMix, self, *mix.values)
      mix
    end

    ##
    # Allows the user to scale the affect of a DSP effect, through control of
    # the "wet" mix, which is the post-processed signal and the "dry" which is
    # the pre-processed signal.
    #
    # The dry signal path is silent by default, because dsp effects transform
    # the input and pass the newly processed result to the output. It does not
    # add to the input.
    #
    # @param pre_wet [Float] Floating point value from 0 to 1, describing a
    #   linear scale of the "wet" (pre-processed signal) mix of the effect.
    #   Scale can be lower than 0 (negating) and higher than 1 (amplifying). *
    #   * *Default:* 1.0
    # @param post_wet [Float] Floating point value from 0 to 1, describing a
    #   linear scale of the "wet" (post-processed signal) mix of the effect.
    #   Scale can be lower than 0 (negating) and higher than 1 (amplifying).
    #   * *Default:* 1.0
    # @param dry [Float] Floating point value from 0 to 1, describing a linear
    #   scale of the "dry" (pre-processed signal) mix of the effect. Scale can
    #   be lower than 0 and higher than 1 (amplifying).
    #   * *Default:* 0.0
    #
    # @return [self]
    def set_wet_dry_mix(pre_wet, post_wet, dry)
      FMOD.invoke(:DSP_SetWetDryMix, self, pre_wet, post_wet, dry)
      self
    end

    # @!attribute channel_format
    # @return [ChannelFormat] The signal format of a DSP unit so that the signal
    #   is processed on the speakers specified.
    # @see ChannelFormat
    def channel_format
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:DSP_GetChannelFormat, self, *args)
      args.map! { |arg| arg.unpack1('L') }
      ChannelFormat.new(*args)
    end

    def channel_format=(format)
      FMOD.type?(format, ChannelFormat)
      FMOD.invoke(:DSP_GetChannelFormat, self, *format.values)
      format
    end

    ##
    # @return [DspInfo] the information about the current DSP unit, including
    # name, version, default channels and width and height of configuration
    # dialog box if it exists.
    def info
      name, vs = "\0" * 32, "\0" * SIZEOF_INT
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:DSP_GetInfo, self, name, vs, *args)
      args = args.map { |arg| arg.unpack1('l') }
      vs = vs.unpack1('L').to_s(16).rjust(8, '0')
      version = "#{vs[0, 4].to_i}.#{vs[4, 4].to_i}"
      DspInfo.new(name.delete("\0"), version, *args)
    end

    ##
    # Calls the DSP unit's reset function, which will clear internal buffers and
    # reset the unit back to an initial state.
    #
    # Calling this function is useful if the DSP unit relies on a history to
    # process itself (ie an echo filter).
    #
    # If you disconnected the unit and reconnected it to a different part of the
    # network with a different sound, you would want to call this to reset the
    # units state (ie clear and reset the echo filter) so that you dont get left
    # over artifacts from the place it used to be connected.
    #
    # @return [void]
    def reset
      FMOD.invoke(:DSP_Reset, self)
    end

    ##
    # @!attribute [r] parent
    # @return [System] the parent {System} object that was used to create this
    #   object.
    def parent
      FMOD.invoke(:DSP_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    ##
    # Display or hide a DSP unit configuration dialog box inside the target
    # window.
    #
    # @param hwnd [Pointer] Target HWND in windows to display configuration
    #   dialog.
    # @param show [Boolean] +true+ to display the window within the parent
    #   window, otherwise +false+ to remove it.
    #
    # @return [void]
    def show_dialog(hwnd, show = true)
      FMOD.invoke(:DSP_ShowConfigDialog, self, hwnd, show.to_i)
    end

    ##
    # Retrieve information about a specified parameter within the DSP unit.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [ParameterInfo, nil] the information about the specified parameter
    #   or +nil+ if the index was out of range.
    def param_info(index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_GetParameterInfo, self, index, info = int_ptr)
      ParameterInfo.new(info.unpack1('J'))
    end

    ##
    # Helper function to disconnect either all inputs or all outputs of a DSP
    # unit.
    #
    # @param inputs [Boolean] +true+ to disconnect all inputs to this DSP unit,
    #   otherwise +false+ to leave input connections alone.
    # @param outputs [Boolean] +true+ to disconnect all outputs to this DSP
    #   unit, otherwise +false+ to leave output connections alone.
    #
    # @return [void]
    def disconnect(inputs, outputs)
      FMOD.invoke(:DSP_DisconnectAll, self, inputs.to_i, outputs.to_i)
    end

    ##
    # Disconnect the DSP unit from the specified input.
    #
    # @param dsp [Dsp] The input unit that this unit is to be disconnected from.
    # @param connection [DspConnection] If there is more than one connection
    #   between 2 dDSP units, this can be used to define which of the
    #   connections should be disconnected.
    #
    # @note If you have a handle to the connection pointer that binds these 2
    #   DSP units, then it will become invalid. The connection is then sent back
    #   to a freelist to be re-used again by a later addInput command.
    #
    # @return [void]
    def disconnect_from(dsp, connection = nil)
      FMOD.type?(dsp, Dsp) unless dsp.nil?
      FMOD.type?(connection, DspConnection) unless connection.nil?
      FMOD.invoke(:DSP_DisconnectFrom, self, dsp, connection)
    end

    ##
    # Retrieves a DSP unit which is acting as an input to this unit.
    #
    # @param index [Integer] Index of the input unit to retrieve.
    #
    # @return [Dsp] the input unit.
    def input(index)
      input = int_ptr
      FMOD.invoke(:DSP_GetInput, self, index, input, nil)
      Dsp.from_handle(input)
    end

    ##
    # Retrieves a DSP unit which is acting as an output to this unit.
    #
    # @param index [Integer] Index of the output unit to retrieve.
    #
    # @return [Dsp] the output unit.
    def output(index)
      output = int_ptr
      FMOD.invoke(:DSP_GetOutput, self, index, output, nil)
      Dsp.from_handle(output)
    end

    ##
    # Retrieves the connection which to a DSP acting as an input to this unit.
    #
    # @param index [Integer] Index of the input unit to retrieve the connection.
    #
    # @return [DspConnection] the input unit connection.
    def input_connection(index)
      connection = int_ptr
      FMOD.invoke(:DSP_GetInput, self, index, nil, connection)
      DspConnection.new(connection)
    end

    ##
    # Retrieves the connection which to a DSP acting as an output to this unit.
    #
    # @param index [Integer] Index of the output unit to retrieve the connection.
    #
    # @return [DspConnection] the output unit connection.
    def output_connection(index)
      connection = int_ptr
      FMOD.invoke(:DSP_GetOutput, self, index, nil, connection)
      DspConnection.new(connection)
    end

    ##
    # Adds the specified DSP unit as an input of the DSP object.
    #
    # @param dsp [Dsp] The DSP unit to add as an input of the current unit.
    # @param type [Integer] The type of connection between the 2 units. The
    #   following are valid values.
    #   * {DspConnection::STANDARD}
    #   * {DspConnection::SIDECHAIN}
    #   * {DspConnection::SEND}
    #   * {DspConnection::SEND_SIDECHAIN}
    #
    # @return [DspConnection] the connection between the 2 units.
    def add_input(dsp, type)
      FMOD.type?(dsp, Dsp)
      connection = int_ptr
      FMOD.invoke(:DSP_AddInput, self, dsp, connection, type)
      DspConnection.new(connection)
    end

    ##
    # Call the DSP process function to retrieve the output signal format for a
    # DSP based on input values.
    #
    # A DSP unit may be an up mixer or down mixer for example. In this case if
    # you specified 6 in for a down-mixer, it may provide you with 2 out for
    # example.
    #
    # Generally the input values will be reproduced for the output values, but
    # some DSP units will want to alter the output format.
    #
    # @overload output_format(format)
    #   @param format [ChannelFormat] Structure describing the incoming channel
    #     format.
    # @overload output_format(mask, count, speaker_mode)
    #   @param mask [Integer] Channel bit-mask representing the speakers enabled
    #     for the incoming signal.
    #   @param count [Integer] Number of channels for the incoming signal.
    #   @param speaker_mode [Integer] Speaker mode for the incoming signal.
    #
    # @return [ChannelFormat] the output signal format.
    def output_format(*args)
      if args.size == 3 && args.all? { |arg| arg.is_a?(Integer) }
        mask, count, mode = args
      elsif args.size == 1 && FMOD.type?(args[0], ChannelFormat)
        mask, count, mode = args[0].values
      else
        mask, count, mode = channel_format.values
      end
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:DSP_GetOutputChannelFormat, mask, count, mode, *args)
      args.map! { |arg| arg.unpack1('L') }
      ChannelFormat.new(*args)
    end

    ##
    # @return [Boolean] a flag indicating if input metering for the DSP it is
    #   enabled or not.
    def input_metering?
      enabled = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetMeteringEnabled, self, enabled, nil)
      enabled.unpack1('l') != 0
    end

    ##
    # @return [Boolean] a flag indicating if output metering for the DSP it is
    #   enabled or not.
    def output_metering?
      enabled = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetMeteringEnabled, self, nil, enabled)
      enabled.unpack1('l') != 0
    end

    ##
    # Enable metering for a DSP unit.
    #
    # @param input [Boolean] Enable metering for the input signal
    #   (pre-processing). Specify +true+ to turn on input level metering,
    #   +false+ to turn it off.
    # @param output [Boolean] Enable metering for the output signal
    #   (post-processing). Specify +true+ to turn on output level metering,
    #   +false+ to turn it off.
    #
    # @return [void]
    def enable_metering(input, output)
      FMOD.invoke(:DSP_SetMeteringEnabled, self, input ? 1 :0, output.to_i)
    end

    ##
    # Retrieves the unit's float parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [Float, nil] the parameter specified, or +nil+ if index is out
    #   of range.
    def get_float(index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:DSP_GetParameterFloat, self, index, buffer, nil, 0)
      buffer.unpack1('f')
    end

    ##
    # Retrieves the unit's integer parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [Integer, nil] the parameter specified, or +nil+ if index is out
    #   of range.
    def get_integer(index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterInt, self, index, buffer, nil, 0)
      buffer.unpack1('l')
    end

    ##
    # Retrieves the unit's boolean parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [Boolean, nil] the parameter specified, or +nil+ if index is out
    #   of range.
    def get_bool(index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterBool, self, index, buffer, nil, 0)
      buffer.unpack1('l') != 0
    end

    ##
    # Retrieves the unit's data parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [Pointer, nil] the parameter specified, or +nil+ if index is out
    #   of range.
    def get_data(index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      pointer = int_ptr
      size = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterData, self, index, pointer, size, nil, 0)
      Pointer.new(pointer.unpack('J'), size.unpack1('l'))
    end

    ##
    # Sets the unit's float parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    # @param value [Float] The value to set.
    #
    # @return [self]
    def set_float(index, value)
      return unless FMOD.valid_range?(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterFloat, self, index, value)
      self
    end

    ##
    # Sets the unit's integer parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    # @param value [Integer] The value to set.
    #
    # @return [self]
    def set_integer(index, value)
      return unless FMOD.valid_range?(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterInt, self, index, value)
      self
    end

    ##
    # Sets the unit's boolean parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    # @param value [Boolean] The value to set.
    #
    # @return [self]
    def set_bool(index, value)
      return unless FMOD.valid_range?(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterBool, self, index, value.to_i)
      self
    end

    ##
    # Sets the unit's data parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    # @param value [Pointer, String] The value to set.
    #
    # @return [self]
    def set_data(index, value)
      return unless FMOD.valid_range?(index, 0, parameter_count, false)
      unless FMOD.type?(value, String, false)
        FMOD.type?(value, Pointer)
      end
      size = value.is_a?(String) ? value.bytesize : value.size
      FMOD.invoke(:DSP_SetParameterData, self, index, value, size)
      self
    end

    ##
    # Get parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    #
    # @return [Object] the value of the parameter at the specified index.
    def [](index)
      return nil unless FMOD.valid_range?(index, 0, parameter_count, false)
      case param_info(index).type
      when ParameterType::FLOAT then get_float(index)
      when ParameterType::INT then get_integer(index)
      when ParameterType::BOOL then get_integer(index)
      when ParameterType::DATA then get_data(index)
      else raise RangeError, 'Unknown data type.'
      end
    end

    ##
    # Sets parameter by index.
    #
    # @param index [Integer] Parameter index for this unit.
    # @param value [Float, Integer, Boolean, Pointer, String] The value to set.
    #
    # @note The value must be of the correct type for the specified parameter,
    #   no implicit conversions will be performed, i.e. passing an integer to a
    #   float parameter will fail, as it is not the correct type. It is up to
    #   the user to perform any conversions ahead before passing to this method.
    #
    # @return [Object] the value of the parameter at the specified index.
    def []=(index, value)
      return unless FMOD.valid_range?(index, 0, parameter_count, false)
      case value
      when Float then set_float(index, value)
      when Integer then set_integer(index, value)
      when TrueClass, FalseClass, NilClass then set_bool(index, value)
      when String, Pointer then set_data(index, value)
      else raise TypeError, "#{value} is not a valid DSP parameter type."
      end
    end

    ##
    # @return [String] the string representation of the DSP unit.
    def to_s
      "#{name} v.#{version}"
    end

    class << self

      ##
      # Dynamically creates a method for getting and/or setting a named float
      # parameter of a DSP unit.
      #
      # @param index [Integer] The parameter index.
      # @param name [Symbol] The name of the attribute to define.
      # @param options [Hash] The options hash.
      #
      # @option options [Boolean] :readonly (false) Flag indicating if a setter
      #   function will be defined or not.
      # @option options [Boolean] :write_only (false) Flag indicating if a
      #   getter will be defined or not.
      # @option options [Float] :min (nil) If defined will clamp any given value
      #   to the specified minimum value.
      # @option options [Float] :max (nil) If defined will clamp any given value
      #   to the specified maximum value.
      #
      # @return [void]
      # @api private
      def float_param(index, name, **options)
        define_method(name) { get_float(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") do |value|
            value = options[:min] if options[:min] && value < options[:min]
            value = options[:max] if options[:max] && value > options[:max]
            set_float(index, value)
          end
        end
      end

      ##
      # Dynamically creates a method for getting and/or setting a named integer
      # parameter of a DSP unit.
      #
      # @param index [Integer] The parameter index.
      # @param name [Symbol] The name of the attribute to define.
      # @param options [Hash] The options hash.
      #
      # @option options [Boolean] :readonly (false) Flag indicating if a setter
      #   function will be defined or not.
      # @option options [Boolean] :write_only (false) Flag indicating if a
      #   getter will be defined or not.
      # @option options [Integer] :min (nil) If defined will clamp any given
      #   value to the specified minimum value.
      # @option options [Integer] :max (nil) If defined will clamp any given
      #   value to the specified maximum value.
      #
      # @return [void]
      # @api private
      def integer_param(index, name, **options)
        define_method(name) { get_integer(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") do |value|
            value = options[:min] if options[:min] && value < options[:min]
            value = options[:max] if options[:max] && value > options[:max]
            set_float(index, value)
          end
        end
      end

      ##
      # Dynamically creates a method for getting and/or setting a named boolean
      # parameter of a DSP unit.
      #
      # @param index [Integer] The parameter index.
      # @param name [Symbol] The name of the attribute to define.
      # @param options [Hash] The options hash.
      #
      # @option options [Boolean] :readonly (false) Flag indicating if a setter
      #   function will be defined or not.
      # @option options [Boolean] :write_only (false) Flag indicating if a
      #   getter will be defined or not.
      #
      # @return [void]
      # @api private
      def bool_param(index, name, **options)
        define_method(name) { get_bool(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") { |value| set_bool(index, value) }
        end
      end

      ##
      # Dynamically creates a method for getting and/or setting a named data
      # parameter of a DSP unit.
      #
      # @param index [Integer] The parameter index.
      # @param name [Symbol] The name of the attribute to define.
      # @param options [Hash] The options hash.
      #
      # @option options [Boolean] :readonly (false) Flag indicating if a setter
      #   function will be defined or not.
      # @option options [Boolean] :write_only (false) Flag indicating if a
      #   getter will be defined or not.
      #
      # @return [void]
      # @api private
      def data_param(index, name, **options)
        define_method(name) { get_data(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") { |value| set_data(index, value) }
        end
      end
    end
  end
end