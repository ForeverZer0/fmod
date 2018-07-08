require 'fiddle'
require 'fiddle/import'

module FMOD
  class Handle < Fiddle::Pointer

    include Fiddle
    include FMOD::Core

    def initialize(address)
      address = address.unpack1('J') if address.is_a?(String)
      super(address.to_i)
    end

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

    def to_s
      inspect # TODO
    end

    def int_ptr
      "\0" * SIZEOF_INTPTR_T
    end

    private

    def self.bool_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_INT)
        buffer.unpack1('l') != 0
      end
    end

    def self.bool_writer(name, function)
      self.send(:define_method, name) do |bool|
        FMOD.invoke(function, self, bool.to_i)
      end
    end

    def self.integer_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_INT)
        buffer.unpack1('l')
      end
    end

    def self.integer_writer(name, function, min = nil, max = nil)
      self.send(:define_method, name) do |int|
        int = min if min && int < min
        int = max if max && int > max
        FMOD.invoke(function, self, int)
        int
      end
    end

    def self.float_reader(name, function)
      self.send(:define_method, name) do
        FMOD.invoke(function, self, buffer = "\0" * SIZEOF_FLOAT)
        buffer.unpack1('f')
      end
    end

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