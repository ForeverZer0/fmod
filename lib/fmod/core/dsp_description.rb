module FMOD
  module Core

    ##
    # When creating a DSP unit, declare one of these and provide the relevant
    # callbacks and name for FMOD to use when it creates and uses a DSP unit of
    # this type.
    # @since 0.9.2
    class DspDescription < Structure

      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address)
        types = [:plugin_sdk_version, :name, :version, :input_buffers,
                 :output_buffers, :create, :release, :reset, :read, :process,
                 :set_position, :parameter_count, :parameter_description,
                 :set_param_float, :set_param_int, :set_param_bool,
                 :set_param_data, :get_param_float, :get_param_int,
                 :get_param_bool, :get_param_data, :should_process, :user_data,
                 :register, :deregister, :mix]
        members = [TYPE_INT, [TYPE_CHAR, 32], TYPE_INT, TYPE_INT, TYPE_INT,
                   TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP,
                   TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP,
                   TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP,
                   TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP,
                   TYPE_VOIDP]
        super(address, types, members)
      end

      [:plugin_sdk_version, :name, :version, :input_buffers, :output_buffers,
       :create, :release, :reset, :read, :process, :set_position,
       :parameter_count, :parameter_description, :set_param_float,
       :set_param_int, :set_param_bool, :set_param_data, :get_param_float,
       :get_param_int, :get_param_bool, :get_param_data, :should_process,
       :user_data, :register, :deregister, :mix].each do |symbol|

        define_method(symbol) { self[symbol] }
        define_method("#{symbol}=") { |value| self[symbol] = value }
      end

      ##
      # @!attribute plugin_sdk_version
      # @return [Integer] the plugin SDK version this plugin is built for.

      ##
      # @!attribute name
      # @return [String] the identifier of the DSP. This will also be used as
      #   the name of DSP and shouldn't change between versions.

      def name
        self[:name].join.delete("\0")
      end

      def name=(name)
        chars = name.chars.slice(0, 32)
        chars << "\0" while chars.size < 32
        self[:name] = chars
      end

      ##
      # @!attribute version
      # @return [Integer] the plugin writer's version number.

      # @!attribute input_buffers
      # @return [Integer] the number of input buffers to process. Use 0 for DSPs
      #   that only generate sound and 1 for effects that process incoming sound

      ##
      # @!attribute output_buffers
      # @return [Integer] the number of audio output buffers. Only one output
      #   buffer is currently supported.

      ##
      # @!attribute create
      # @return [Closure] Create callback. This is called when DSP unit is
      #   created.

      ##
      # @!attribute release
      # @return [Closure] Release callback. This is called just before the unit
      #   is freed so the user can do any cleanup needed for the unit.

      ##
      # @!attribute reset
      # @return [Closure] Reset callback. This is called by the user to reset
      #   any history buffers that may need resetting for a filter, when it is
      #   to be used or re-used for the first time to its initial clean state.
      #   Use to avoid clicks or artifacts.

      ##
      # @!attribute read
      # @return [Closure] Read callback. Processing is done here.

      ##
      # @!attribute process
      # @return [Closure] Process callback. Can be specified instead of the read
      #   callback if any channel format changes occur between input and output.
      #   This also replaces {#should_process} and should return an error if the
      #   effect is to be bypassed.

      ##
      # @!attribute set_position
      # @return [Closure] Set position callback. This is called if the unit
      #   wants to update its position info but not process data, or reset a
      #   cursor position internally if it is reading data from a certain
      #   source.

      ##
      # @!attribute parameter_count
      # @return [Integer] the of parameters used in this filter.

      ##
      # @!attribute parameter_description
      # @return [Pointer] a variable number of parameter structures.

      ##
      # @!attribute set_param_float
      # @return [Closure] Called when the user sets a float parameter.

      ##
      # @!attribute set_param_int
      # @return [Closure] Called when the user sets an integer parameter.

      ##
      # @!attribute set_param_bool
      # @return [Closure] Called when the user sets a boolean parameter.

      ##
      # @!attribute set_param_data
      # @return [Closure] Called when the user sets a data parameter.

      ##
      # @!attribute get_param_float
      # @return [Closure] Called when the user gets a float parameter.

      ##
      # @!attribute get_param_int
      # @return [Closure] Called when the user gets an integer parameter.

      ##
      # @!attribute get_param_bool
      # @return [Closure] Called when the user sets a boolean parameter.

      ##
      # @!attribute get_param_data
      # @return [Closure] Called when the user sets a data parameter.

      ##
      # @!attribute should_process
      # @return [Closure] This is called before processing. You can detect if
      #   inputs are idle and return Result::OK to process, or any other error
      #   code to avoid processing the effect. Use a count down timer to allow
      #   effect tails to process before idling!

      ##
      # @!attribute user_data
      # @return [Pointer] the user data to be attached to the DSP unit during
      #   creation.

      # @!attribute register
      # @return [Closure] Register callback. This is called when DSP unit is
      #   loaded/registered. Useful for 'global'/per system object init for
      #   plugin.

      # @!attribute register
      # @return [Closure] Deregister callback. This is called when DSP unit is
      #   unloaded/deregistered. Useful as 'global'/per system object shutdown
      #   for plugin.

      # @!attribute register
      # @return [Closure] System mix stage callback. This is called when the
      #   mixer starts to execute or is just finishing executing. Useful for
      #   'global'/per system object once a mix update calls for a plugin.

    end
  end
end