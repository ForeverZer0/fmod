module FMOD

  # @attr wet_dry_mix [WetDryMix] Allows the user to scale the affect of a DSP
  #   effect, through control of the "wet" mix, which is the post-processed
  #   signal and the "dry" which is the pre-processed signal.
  #
  #   The dry signal path is silent by default, because DSP effects transform
  #   the input and pass the newly processed result to the output. It does not
  #   add to the input.
  class Dsp < Handle

    ChannelFormat = Struct.new(:mask, :count, :speaker_mode)

    DspInfo = Struct.new(:name, :version, :channels, :width, :height) do
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

    def param_info(index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_GetParameterInfo, self, index, info = int_ptr)
      ParameterInfo.new(info.unpack1('J'))
    end

    def to_s
      "#{name} v.#{version}"
    end

    def info
      name, vs = "\0" * 32, "\0" * SIZEOF_INT
      args = ["\0" * SIZEOF_INT, "\0" * SIZEOF_INT, "\0" * SIZEOF_INT]
      FMOD.invoke(:DSP_GetInfo, self, name, vs, *args)
      args = args.map { |arg| arg.unpack1('l') }
      vs = vs.unpack1('L').to_s(16).rjust(8, '0')
      version = "#{vs[0, 4].to_i}.#{vs[4, 4].to_i}"
      DspInfo.new(name.delete("\0"), version, *args)
    end

    def reset
      FMOD.invoke(:DSP_Reset, self)
    end

    def parent
      FMOD.invoke(:DSP_GetSystemObject, self, system = int_ptr)
      System.new(system)
    end

    def show_dialog(hwnd, show = true)
      FMOD.invoke(:DSP_ShowConfigDialog, self, hwnd, show.to_i)
    end

    def disconnect(inputs, outputs)
      FMOD.invoke(:DSP_DisconnectAll, self, inputs.to_i, outputs.to_i)
    end

    def disconnect_from(dsp, connection = nil)
      FMOD.type?(dsp, Dsp) unless dsp.nil?
      FMOD.type?(connection, DspConnection) unless connection.nil?
      FMOD.invoke(:DSP_DisconnectFrom, self, dsp, connection)
    end

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

    def input(index)
      input = int_ptr
      FMOD.invoke(:DSP_GetInput, self, index, input, nil)
      Dsp.from_handle(input)
    end

    def output(index)
      output = int_ptr
      FMOD.invoke(:DSP_GetOutput, self, index, output, nil)
      Dsp.from_handle(output)
    end

    def input_connection(index)
      connection = int_ptr
      FMOD.invoke(:DSP_GetInput, self, index, nil, connection)
      DspConnection.new(connection)
    end

    def output_connection(index)
      connection = int_ptr
      FMOD.invoke(:DSP_GetOutput, self, index, nil, connection)
      DspConnection.new(connection)
    end

    def add_input(dsp, type)
      FMOD.type?(dsp, Dsp)
      connection = int_ptr
      FMOD.invoke(:DSP_AddInput, self, dsp, connection, type)
      DspConnection.new(connection)
    end

    def input_metering?
      enabled = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetMeteringEnabled, self, enabled, nil)
      enabled.unpack1('l') != 0
    end

    def output_metering?
      enabled = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetMeteringEnabled, self, nil, enabled)
      enabled.unpack1('l') != 0
    end

    def enable_metering(input, output)
      FMOD.invoke(:DSP_SetMeteringEnabled, self, input ? 1 :0, output.to_i)
    end

    def [](index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      case param_info(index).type
      when ParameterType::FLOAT then get_float(index)
      when ParameterType::INT then get_integer(index)
      when ParameterType::BOOL then get_integer(index)
      when ParameterType::DATA then get_data(index)
      else raise RangeError, 'Unknown data type.'
      end
    end

    def get_float(index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:DSP_GetParameterFloat, self, index, buffer, nil, 0)
      buffer.unpack1('f')
    end

    def get_integer(index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterInt, self, index, buffer, nil, 0)
      buffer.unpack1('l')
    end

    def get_bool(index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      buffer = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterBool, self, index, buffer, nil, 0)
      buffer.unpack1('l') != 0
    end

    def get_data(index)
      return nil unless FMOD.check_range(index, 0, parameter_count, false)
      pointer = int_ptr
      size = "\0" * SIZEOF_INT
      FMOD.invoke(:DSP_GetParameterData, self, index, pointer, size, nil, 0)
      Pointer.new(pointer.unpack('J'), size.unpack1('l'))
    end

    def []=(index, value)
      return unless FMOD.check_range(index, 0, parameter_count, false)
      case value
      when Float then set_float(index, value)
      when Integer then set_integer(index, value)
      when TrueClass, FalseClass, NilClass then set_bool(index, value)
      when String, Pointer then set_data(index, value)
      else raise TypeError, "#{value} is not a valid DSP parameter type."
      end
    end

    def set_float(index, value)
      return unless FMOD.check_range(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterFloat, self, index, value)
      self
    end

    def set_integer(index, value)
      return unless FMOD.check_range(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterInt, self, index, value)
      self
    end

    def set_bool(index, value)
      return unless FMOD.check_range(index, 0, parameter_count, false)
      FMOD.invoke(:DSP_SetParameterBool, self, index, value.to_i)
      self
    end

    def set_data(index, value)
      return unless FMOD.check_range(index, 0, parameter_count, false)
      unless FMOD.type?(value, String, false)
        FMOD.type?(value, Pointer)
      end
      size = value.is_a?(String) ? value.bytesize : value.size
      FMOD.invoke(:DSP_SetParameterData, self, index, value, size)
      self
    end


    class << self

      private

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

      def bool_param(index, name, **options)
        define_method(name) { get_bool(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") { |value| set_bool(index, value) }
        end
      end

      def data_param(index, name, **options)
        define_method(name) { get_data(index) } unless options[:write_only]
        unless options[:readonly]
          define_method("#{name}=") { |value| set_data(index, value) }
        end
      end
    end
    # def self.float_param(index, name, **options)
    #   define_method(name) { get_float(index) } unless options[:write_only]
    #   unless options[:readonly]
    #     define_method("#{name}=") do |value|
    #       value = options[:min] if options[:min] && value < options[:min]
    #       value = options[:max] if options[:max] && value > options[:max]
    #       set_float(index, value)
    #     end
    #   end
    # end
    #
    # def self.integer_param(index, name, **options)
    #   define_method(name) { get_integer(index) } unless options[:write_only]
    #   unless options[:readonly]
    #     define_method("#{name}=") do |value|
    #       value = options[:min] if options[:min] && value < options[:min]
    #       value = options[:max] if options[:max] && value > options[:max]
    #       set_float(index, value)
    #     end
    #   end
    # end
    #
    # def self.bool_param(index, name, **options)
    #   define_method(name) { get_bool(index) } unless options[:write_only]
    #   unless options[:readonly]
    #     define_method("#{name}=") { |value| set_bool(index, value) }
    #   end
    # end
    #
    # def self.data_param(index, name, **options)
    #   define_method(name) { get_data(index) } unless options[:write_only]
    #   unless options[:readonly]
    #     define_method("#{name}=") { |value| set_data(index, value) }
    #   end
    # end
  end
end