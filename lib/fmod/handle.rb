require 'fiddle'
require 'fiddle/import'

module FMOD

  ##
  # @abstract The superclass for all core FMOD classes.
  # Contains a reference handle to an unmanaged object, and as such it is
  # crucial to call {#release} on any derived class to prevent memory leaks.
  class Handle < Fiddle::Pointer

    include Fiddle
    include FMOD::Core

    ##
    # @param address [Pointer, Integer, String] The address of a native FMOD
    #   pointer.
    def initialize(address)
      address = address.unpack1('J') if address.is_a?(String)
      super(address.to_i)
    end

    ##
    # Releases the native handle.
    # Failure to call this function may result in memory leaks.
    # @return [void]
    def release
      case self
      when Sound then FMOD.invoke(:Sound_Release, self)
      when Dsp then FMOD.invoke(:DSP_Release, self)
      when ChannelGroup then FMOD.invoke(:ChannelGroup_Release, self)
      when Geometry then FMOD.invoke(:Geometry_Release, self)
      when Reverb3D then FMOD.invoke(:Reverb3D_Release, self)
      when SoundGroup then FMOD.invoke(:SoundGroup_Release, self)
      when System then FMOD.invoke(:System_Release, self)
      end
    end

    alias_method :dispose, :release

    # @!attribute user_data
    # @return [Pointer] a user value stored within the object.

    def user_data
      pointer = int_ptr
      case self
      when ChannelControl
        FMOD.invoke(:ChannelGroup_GetUserData, self, pointer)
      when Dsp
        FMOD.invoke(:DSP_GetUserData, self, pointer)
      when DspConnection
        FMOD.invoke(:DSPConnection_GetUserData, self, pointer)
      when Geometry
        FMOD.invoke(:Geometry_GetUserData, self, pointer)
      when Reverb3D
        FMOD.invoke(:Reverb3D_GetUserData, self, pointer)
      when Sound
        FMOD.invoke(:Sound_GetUserData, self, pointer)
      when SoundGroup
        FMOD.invoke(:SoundGroup_GetUserData, self, pointer)
      when System
        FMOD.invoke(:System_GetUserData, self, pointer)
      end
      Pointer.new(pointer.unpack1('J'))
    end

    def user_data=(pointer)
      case self
      when ChannelControl
        FMOD.invoke(:ChannelGroup_SetUserData, self, pointer)
      when Dsp
        FMOD.invoke(:DSP_SetUserData, self, pointer)
      when DspConnection
        FMOD.invoke(:DSPConnection_SetUserData, self, pointer)
      when Geometry
        FMOD.invoke(:Geometry_SetUserData, self, pointer)
      when Reverb3D
        FMOD.invoke(:Reverb3D_SetUserData, self, pointer)
      when Sound
        FMOD.invoke(:Sound_SetUserData, self, pointer)
      when SoundGroup
        FMOD.invoke(:SoundGroup_SetUserData, self, pointer)
      when System
        FMOD.invoke(:System_SetUserData, self, pointer)
      end
      pointer
    end

    ##
    # @return [String] the string representation of the object.
    def to_s
      inspect # TODO
    end

    ##
    # @return [String] an empty string buffer the size of the platforms pointer
    #   size.
    def int_ptr
      "\0" * SIZEOF_INTPTR_T
    end

    private

    ##
    # Dynamically links a Ruby method to get a boolean value from a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix may be omitted.
    #
    # @return [void]
    def self.bool_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_INT)
        buffer.unpack1('l') != 0
      end
    end

    ##
    # Dynamically links a Ruby method to set a boolean value in a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix can be omitted.
    #
    # @return [void]
    def self.bool_writer(name, function)
      self.send(:define_method, name) do |bool|
        FMOD.invoke(function, self, bool.to_i)
      end
    end

    ##
    # Dynamically links a Ruby method to get an integer value from a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix may be omitted.
    #
    # @return [void]
    def self.integer_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_INT)
        buffer.unpack1('l')
      end
    end

    ##
    # Dynamically links a Ruby method to set an integer value in a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix can be omitted.
    # @param min [Numeric] The minimum permitted value that can be passed to
    #   the defined method. Values out of range will be clamped.
    # @param max [Numeric] The maximum permitted value that can be passed to
    #   the defined method. Values out of range will be clamped.
    #
    # @return [void]
    def self.integer_writer(name, function, min = nil, max = nil)
      self.send(:define_method, name) do |int|
        int = min if min && int < min
        int = max if max && int > max
        FMOD.invoke(function, self, int)
        int
      end
    end

    ##
    # Dynamically links a Ruby method to get a float value from a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix may be omitted.
    #
    # @return [void]
    def self.float_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_FLOAT)
        buffer.unpack1('f')
      end
    end

    ##
    # Dynamically links a Ruby method to set a float value in a native
    # FMOD function.
    #
    # @param name [Symbol] The Ruby method name to be defined.
    # @param function [Symbol] The native FMOD function to import.
    #   The "FMOD_" prefix can be omitted.
    # @param min [Numeric] The minimum permitted value that can be passed to
    #   the defined method. Values out of range will be clamped.
    # @param max [Numeric] The maximum permitted value that can be passed to
    #   the defined method. Values out of range will be clamped.
    #
    # @return [void]
    def self.float_writer(name, function, min = nil, max = nil)
      self.send(:define_method, name) do |float|
        float = min if min && float < min
        float = max if max && float > max
        FMOD.invoke(function, self, float)
        float
      end
    end
  end
end