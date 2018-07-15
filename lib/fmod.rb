
require 'fiddle'
require 'fiddle/import'
require 'rbconfig'

##
# Top-level namespace containing the entirety of the FMOD API.
# @author Eric "ForeverZer0" Freed
module FMOD

  include Fiddle

  ##
  # Null-pointer (address of 0)
  NULL = Pointer.new(0).freeze

  ##
  # Version number of the wave format codec.
  #
  # Use this for binary compatibility and for future expansion.
  WAVE_FORMAT_VERSION = 3

  ##
  # Array of extensions for supported formats.
  #
  # Additional formats may be supported, or added via plug-ins.
  SUPPORTED_EXTENSIONS = %w(.aiff .asf .asx .dls .flac .fsb .it .m3u .midi .mod .mp2 .mp3 .ogg .pls .s3m .vag .wav .wax .wma .xm .xma)

  ##
  # The maximum number of channels per frame of audio supported by audio files,
  # buffers, connections and DSPs.
  MAX_CHANNEL_WIDTH = 32

  ##
  # The maximum number of listeners supported.
  MAX_LISTENERS = 8

  ##
  # The maximum number of {System} objects allowed.
  MAX_SYSTEMS = 8

  ##
  # The maximum number of global/physical reverb instances.
  #
  # Each instance of a physical reverb is an instance of a {Effects::SfxReverb }
  # DSP in the mix graph. This is unrelated to the number of possible {Reverb3D}
  # objects, which is unlimited.
  MAX_REVERB = 4

  ##
  # Null value for a port index. Use when a port index is not required.
  PORT_INDEX_NONE = 0xFFFFFFFFFFFFFFFF

  require_relative 'fmod/version.rb'
  require_relative 'fmod/core'
  require_relative 'fmod/error'
  require_relative 'fmod/handle'
  require_relative 'fmod/channel_control'
  require_relative 'fmod/channel.rb'
  require_relative 'fmod/channel_group.rb'
  require_relative 'fmod/dsp.rb'
  require_relative 'fmod/effects.rb'
  require_relative 'fmod/dsp_connection.rb'
  require_relative 'fmod/geometry.rb'
  require_relative 'fmod/reverb3D.rb'
  require_relative 'fmod/sound.rb'
  require_relative 'fmod/sound_group.rb'
  require_relative 'fmod/system.rb'

  @function_signatures = {
    ############################################################################
    # Channel
    ############################################################################
    Channel_GetChannelGroup: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_GetCurrentSound: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_GetFrequency: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_GetIndex: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_GetLoopCount: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_GetLoopPoints: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    Channel_GetPosition: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    Channel_GetPriority: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_IsVirtual: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_SetChannelGroup: [TYPE_VOIDP, TYPE_VOIDP],
    Channel_SetFrequency: [TYPE_VOIDP, TYPE_FLOAT],
    Channel_SetLoopCount: [TYPE_VOIDP, TYPE_INT],
    Channel_SetLoopPoints: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT, TYPE_INT],
    Channel_SetPosition: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    Channel_SetPriority: [TYPE_VOIDP, TYPE_INT],
    ############################################################################
    # ChannelGroup
    ############################################################################
    ChannelGroup_AddGroup: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_GetChannel: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_GetGroup: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_GetName: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ChannelGroup_GetNumChannels: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetNumGroups: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetParentGroup: [TYPE_VOIDP, TYPE_VOIDP],
    ############################################################################
    # ChannelControl
    ############################################################################
    ChannelGroup_AddDSP: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_AddFadePoint: [TYPE_VOIDP, TYPE_LONG_LONG, TYPE_FLOAT],
    ChannelGroup_Get3DAttributes: Array.new(4, TYPE_VOIDP),
    ChannelGroup_Get3DConeOrientation: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Get3DConeSettings: Array.new(4, TYPE_VOIDP),
    ChannelGroup_Get3DCustomRolloff: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Get3DDistanceFilter: Array.new(4, TYPE_VOIDP),
    ChannelGroup_Get3DDopplerLevel: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Get3DLevel: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Get3DMinMaxDistance: Array.new(3, TYPE_VOIDP),
    ChannelGroup_Get3DOcclusion: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Get3DSpread: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetAudibility: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetDelay: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetDSP: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_GetDSPClock: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetDSPIndex: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetFadePoints: Array.new(4, TYPE_VOIDP),
    ChannelGroup_GetLowPassGain: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetMixMatrix: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ChannelGroup_GetMode: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetMute: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetNumDSPs: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetPaused: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetPitch: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetReverbProperties: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    ChannelGroup_GetSystemObject: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetVolume: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_GetVolumeRamp: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_IsPlaying: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Release: [TYPE_VOIDP],
    ChannelGroup_RemoveDSP: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_RemoveFadePoints: [TYPE_VOIDP, TYPE_LONG_LONG, TYPE_LONG_LONG],
    ChannelGroup_Set3DAttributes: Array.new(4, TYPE_VOIDP),
    ChannelGroup_Set3DConeOrientation: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_Set3DConeSettings: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT],
    ChannelGroup_Set3DCustomRolloff: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ChannelGroup_Set3DDistanceFilter: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT, TYPE_FLOAT],
    ChannelGroup_Set3DDopplerLevel: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_Set3DLevel: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_Set3DMinMaxDistance: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT],
    ChannelGroup_Set3DOcclusion: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT],
    ChannelGroup_Set3DSpread: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_SetCallback: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_SetDelay: [TYPE_VOIDP, TYPE_LONG_LONG, TYPE_LONG_LONG, TYPE_INT],
    ChannelGroup_SetDSPIndex: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ChannelGroup_SetFadePointRamp: [TYPE_VOIDP, TYPE_LONG_LONG, TYPE_FLOAT],
    ChannelGroup_SetLowPassGain: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_SetMixLevelsInput: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ChannelGroup_SetMixLevelsOutput: [TYPE_VOIDP] + Array.new(8, TYPE_FLOAT),
    ChannelGroup_SetMixMatrix: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT],
    ChannelGroup_SetMode: [TYPE_VOIDP, TYPE_INT],
    ChannelGroup_SetMute: [TYPE_VOIDP, TYPE_INT],
    ChannelGroup_SetPan: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_SetPaused: [TYPE_VOIDP, TYPE_INT],
    ChannelGroup_SetPitch: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_SetReverbProperties: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT],
    ChannelGroup_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    ChannelGroup_SetVolume: [TYPE_VOIDP, TYPE_FLOAT],
    ChannelGroup_SetVolumeRamp: [TYPE_VOIDP, TYPE_INT],
    ChannelGroup_Stop: [TYPE_VOIDP],
    ############################################################################
    # Debug
    ############################################################################
    # Debug_Initialize: [TYPE_VOIDP],
    ############################################################################
    # Dsp
    ############################################################################
    DSP_AddInput: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSP_DisconnectAll: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    DSP_DisconnectFrom: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetActive: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetBypass: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetChannelFormat: Array.new(4, TYPE_VOIDP),
    # DSP_GetDataParameterIndex: [TYPE_VOIDP],
    DSP_GetIdle: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetInfo: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetInput: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetMeteringEnabled: Array.new(3, TYPE_VOIDP),
    # DSP_GetMeteringInfo: [TYPE_VOIDP],
    DSP_GetNumInputs: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetNumOutputs: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetNumParameters: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetOutput: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetOutputChannelFormat: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetParameterBool: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSP_GetParameterData: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSP_GetParameterFloat: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSP_GetParameterInfo: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    DSP_GetParameterInt: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSP_GetSystemObject: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetType: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_GetWetDryMix: Array.new(4, TYPE_VOIDP),
    DSP_Release: [TYPE_VOIDP],
    DSP_Reset: [TYPE_VOIDP],
    DSP_SetActive: [TYPE_VOIDP, TYPE_INT],
    DSP_SetBypass: [TYPE_VOIDP, TYPE_INT],
    DSP_SetChannelFormat: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT],
    DSP_SetMeteringEnabled: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    DSP_SetParameterBool: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    DSP_SetParameterData: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    DSP_SetParameterFloat: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT],
    DSP_SetParameterInt: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    DSP_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    DSP_SetWetDryMix: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT],
    DSP_ShowConfigDialog: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    ############################################################################
    # DspConnection
    ############################################################################
    DSPConnection_GetInput: [TYPE_VOIDP, TYPE_VOIDP],
    DSPConnection_GetMix: [TYPE_VOIDP, TYPE_VOIDP],
    DSPConnection_GetMixMatrix: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    DSPConnection_GetOutput: [TYPE_VOIDP, TYPE_VOIDP],
    DSPConnection_GetType: [TYPE_VOIDP, TYPE_VOIDP],
    DSPConnection_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    DSPConnection_SetMix: [TYPE_VOIDP, TYPE_FLOAT],
    DSPConnection_SetMixMatrix: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT],
    DSPConnection_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    ############################################################################
    # File
    ############################################################################
    # File_GetDiskBusy: [TYPE_VOIDP],
    # File_SetDiskBusy: [TYPE_VOIDP],
    ############################################################################
    # Geometry
    ############################################################################
    Geometry_AddPolygon: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetActive: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetMaxPolygons: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetNumPolygons: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetPolygonAttributes: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetPolygonNumVertices: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Geometry_GetPolygonVertex: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    Geometry_GetPosition: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetRotation: Array.new(3, TYPE_VOIDP),
    Geometry_GetScale: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_Release: [TYPE_VOIDP],
    Geometry_Save: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Geometry_SetActive: [TYPE_VOIDP, TYPE_INT],
    Geometry_SetPolygonAttributes: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT],
    Geometry_SetPolygonVertex: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    Geometry_SetPosition: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_SetRotation: Array.new(3, TYPE_VOIDP),
    Geometry_SetScale: [TYPE_VOIDP, TYPE_VOIDP],
    Geometry_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    ############################################################################
    # Memory
    ############################################################################
    # Memory_GetStats: [TYPE_VOIDP],
    # Memory_Initialize: [TYPE_VOIDP],
    ############################################################################
    # Reverb3D
    ############################################################################
    Reverb3D_Get3DAttributes: Array.new(4, TYPE_VOIDP),
    Reverb3D_GetActive: [TYPE_VOIDP, TYPE_VOIDP],
    Reverb3D_GetProperties: [TYPE_VOIDP, TYPE_VOIDP],
    Reverb3D_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    Reverb3D_Release: [TYPE_VOIDP],
    Reverb3D_Set3DAttributes: [TYPE_VOIDP, TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT],
    Reverb3D_SetActive: [TYPE_VOIDP, TYPE_INT],
    Reverb3D_SetProperties: [TYPE_VOIDP, TYPE_VOIDP],
    Reverb3D_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    ############################################################################
    # Sound
    ############################################################################
    Sound_AddSyncPoint: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    Sound_DeleteSyncPoint: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_Get3DConeSettings: Array.new(4, TYPE_VOIDP),
    Sound_Get3DCustomRolloff: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Sound_Get3DMinMaxDistance: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetDefaults: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetFormat: Array.new(5, TYPE_VOIDP),
    Sound_GetLength: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    Sound_GetLoopCount: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetLoopPoints: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    Sound_GetMode: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetMusicChannelVolume: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Sound_GetMusicNumChannels: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetMusicSpeed: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetName: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    Sound_GetNumSubSounds: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetNumSyncPoints: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetNumTags: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetOpenState: Array.new(5, TYPE_VOIDP),
    Sound_GetSoundGroup: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetSubSound: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Sound_GetSubSoundParent: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetSyncPoint: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Sound_GetSyncPointInfo: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    Sound_GetSystemObject: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_GetTag: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Sound_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_Lock: [TYPE_VOIDP, TYPE_INT, TYPE_INT] + Array.new(4, TYPE_VOIDP),
    Sound_ReadData: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    Sound_Release: [TYPE_VOIDP],
    Sound_SeekData: [TYPE_VOIDP, TYPE_INT],
    Sound_Set3DConeSettings: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT],
    Sound_Set3DCustomRolloff: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    Sound_Set3DMinMaxDistance: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT],
    Sound_SetDefaults: [TYPE_VOIDP, TYPE_FLOAT, TYPE_INT],
    Sound_SetLoopCount: [TYPE_VOIDP, TYPE_INT],
    Sound_SetLoopPoints: [TYPE_VOIDP] + Array.new(4, TYPE_INT),
    Sound_SetMode: [TYPE_VOIDP, TYPE_INT],
    Sound_SetMusicChannelVolume: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT],
    Sound_SetMusicSpeed: [TYPE_VOIDP, TYPE_FLOAT],
    Sound_SetSoundGroup: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    Sound_Unlock: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_INT],
    ############################################################################
    # SoundGroup
    ############################################################################
    SoundGroup_GetMaxAudible: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetMaxAudibleBehavior: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetMuteFadeSpeed: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetName: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    SoundGroup_GetNumPlaying: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetNumSounds: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetSound: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    SoundGroup_GetSystemObject: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_GetVolume: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_Release: [TYPE_VOIDP],
    SoundGroup_SetMaxAudible: [TYPE_VOIDP, TYPE_INT],
    SoundGroup_SetMaxAudibleBehavior: [TYPE_VOIDP, TYPE_INT],
    SoundGroup_SetMuteFadeSpeed: [TYPE_VOIDP, TYPE_FLOAT],
    SoundGroup_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    SoundGroup_SetVolume: [TYPE_VOIDP, TYPE_FLOAT],
    SoundGroup_Stop: [TYPE_VOIDP],
    ############################################################################
    # System
    ############################################################################
    System_AttachChannelGroupToPort: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    System_AttachFileSystem: Array.new(5, TYPE_VOIDP),
    System_Close: [TYPE_VOIDP],
    System_Create: [TYPE_VOIDP],
    System_CreateChannelGroup: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    # System_CreateDSP: [TYPE_VOIDP],
    # System_CreateDSPByPlugin: [TYPE_VOIDP],
    System_CreateDSPByType: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_CreateGeometry: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    System_CreateReverb3D: [TYPE_VOIDP, TYPE_VOIDP],
    System_CreateSound: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    System_CreateSoundGroup: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    System_CreateStream: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP],
    System_DetachChannelGroupFromPort: [TYPE_VOIDP, TYPE_VOIDP],
    System_Get3DListenerAttributes: [TYPE_VOIDP, TYPE_INT] + Array.new(4, TYPE_VOIDP),
    System_Get3DNumListeners: [TYPE_VOIDP, TYPE_VOIDP],
    System_Get3DSettings: Array.new(4, TYPE_VOIDP),
    # System_GetAdvancedSettings: [TYPE_VOIDP],
    System_GetChannel: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetChannelsPlaying: Array.new(3, TYPE_VOIDP),
    System_GetCPUUsage: Array.new(6, TYPE_VOIDP),
    System_GetDefaultMixMatrix: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    System_GetDriver: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetDriverInfo: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT] + Array.new(4, TYPE_VOIDP),
    System_GetDSPBufferSize: Array.new(3, TYPE_VOIDP),
    System_GetDSPInfoByPlugin: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetFileUsage: Array.new(4, TYPE_VOIDP),
    System_GetGeometryOcclusion: Array.new(5, TYPE_VOIDP),
    System_GetGeometrySettings: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetMasterChannelGroup: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetMasterSoundGroup: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetNestedPlugin: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    System_GetNetworkProxy: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    System_GetNetworkTimeout: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetNumDrivers: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetNumNestedPlugins: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetNumPlugins: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetOutput: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetOutputByPlugin: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetOutputHandle: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetPluginHandle: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    System_GetPluginInfo: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetRecordDriverInfo: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT] + Array.new(5, TYPE_VOIDP),
    System_GetRecordNumDrivers: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    System_GetRecordPosition: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetReverbProperties: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetSoftwareChannels: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetSoftwareFormat: Array.new(4, TYPE_VOIDP),
    System_GetSoundRAM: Array.new(4, TYPE_VOIDP),
    System_GetSpeakerModeChannels: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_GetSpeakerPosition: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP],
    System_GetStreamBufferSize: Array.new(3, TYPE_VOIDP),
    System_GetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    System_GetVersion: [TYPE_VOIDP, TYPE_VOIDP],
    System_Init: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_VOIDP],
    System_IsRecording: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_LoadGeometry: [TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_LoadPlugin: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT],
    System_LockDSP: [TYPE_VOIDP],
    System_MixerResume: [TYPE_VOIDP],
    System_MixerSuspend: [TYPE_VOIDP],
    System_PlayDSP: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_PlaySound: [TYPE_VOIDP, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_RecordStart: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP, TYPE_INT],
    System_RecordStop: [TYPE_VOIDP, TYPE_INT],
    # System_RegisterCodec: [TYPE_VOIDP],
    # System_RegisterDSP: [TYPE_VOIDP],
    # System_RegisterOutput: [TYPE_VOIDP],
    System_Release: [TYPE_VOIDP],
    System_Set3DListenerAttributes: [TYPE_VOIDP, TYPE_INT] + Array.new(4, TYPE_VOIDP),
    System_Set3DNumListeners: [TYPE_VOIDP, TYPE_INT],
    System_Set3DRolloffCallback: [TYPE_VOIDP, TYPE_VOIDP],
    System_Set3DSettings: [TYPE_VOIDP, TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT],
    # System_SetAdvancedSettings: [TYPE_VOIDP],
    # System_SetCallback: [TYPE_VOIDP],
    System_SetDriver: [TYPE_VOIDP, TYPE_INT],
    System_SetDSPBufferSize: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    # System_SetFileSystem: [TYPE_VOIDP],
    System_SetGeometrySettings: [TYPE_VOIDP, TYPE_FLOAT],
    System_SetNetworkProxy: [TYPE_VOIDP, TYPE_VOIDP],
    System_SetNetworkTimeout: [TYPE_VOIDP, TYPE_INT],
    System_SetOutput: [TYPE_VOIDP, TYPE_INT],
    System_SetOutputByPlugin: [TYPE_VOIDP, TYPE_INT],
    System_SetPluginPath: [TYPE_VOIDP, TYPE_VOIDP],
    System_SetReverbProperties: [TYPE_VOIDP, TYPE_INT, TYPE_VOIDP],
    System_SetSoftwareChannels: [TYPE_VOIDP, TYPE_INT],
    System_SetSoftwareFormat: [TYPE_VOIDP, TYPE_INT, TYPE_INT, TYPE_INT],
    System_SetSpeakerPosition: [TYPE_VOIDP, TYPE_INT, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT],
    System_SetStreamBufferSize: [TYPE_VOIDP, TYPE_INT, TYPE_INT],
    System_SetUserData: [TYPE_VOIDP, TYPE_VOIDP],
    System_UnloadPlugin: [TYPE_VOIDP, TYPE_INT],
    System_UnlockDSP: [TYPE_VOIDP],
    System_Update: [TYPE_VOIDP]
  }

  ##
  # Invokes the specified native function.
  #
  # @param function [Symbol] Symbol name of an FMOD function, without the the
  #   leading "FMOD_" prefix.
  # @raise [Error] if the result code returned by FMOD is not 0.
  # @return [void]
  # @see invoke_protect
  def self.invoke(function, *args)
    result = @functions[function].call(*args)
    raise Error, result unless result.zero?
  end

  ##
  # Invokes the specified native function.
  #
  # The same as {FMOD.invoke}, but returns the result code instead of raising an
  #   exception.
  #
  # @param function [Symbol] Symbol name of an FMOD function, without the the
  #   leading "FMOD_" prefix.
  # @return [Integer] the result code.
  # @see Result
  def self.invoke_protect(function, *args)
    @functions[function].call(*args)
  end

  ##
  # Loads the native FMOD library.
  #
  # @note This must be called before _ANY_ other function is called.
  #
  # @param library [String] The name of the library to load. If omitted, the
  #   default platform-specific library name will be used.
  # @param directory [String] The directory where the library will be loaded
  #   from. By default this will be the "./ext" folder relative to the gem
  #   installation folder.
  #
  # @return [true] if no errors occurred, otherwise exception will be raised.
  def self.load_library(library = nil, directory = nil)
    if library.nil?
      library =  case platform
      when :WINDOWS then SIZEOF_INTPTR_T == 4 ? 'fmod.dll' : 'fmod64.dll'
      when :MACOSX then 'libfmod.dylib'
      when :LINUX then 'libfmod.so'
      else 'fmod'  # Will probably fail...
      end
    end
    path = File.expand_path(File.join(directory || Dir.getwd, library))
    lib = Fiddle.dlopen(path)
    import_symbols(lib)
    true
  end

  # @return [Symbol] a symbol representing the operating system. Will be either
  #   *:WINDOWS*, *:MACOSX*, or *:LINUX*.
  def self.platform
    @platform ||= case RbConfig::CONFIG['host_os']
    when /mswin|msys|mingw|cygwin/ then :WINDOWS
    when /darwin/ then :MACOSX
    when /linux/ then :LINUX
    else raise RuntimeError, 'Unsupported operating system.'
    end
  end

  ##
  # Imports the FMOD functions from the loaded library.
  #
  # @note This function is called automatically, not to be called by the user.
  #
  # @return [void]
  def self.import_symbols(library)
    @functions = {}
    @function_signatures.each_pair do |sym, signature|
      name = "FMOD_#{sym}"
      begin
        @functions[sym] = Function.new(library[name], signature, TYPE_INT)
      rescue Fiddle::DLError
        warn("Failed to import #{name}.")
      end
    end
    const_set(:ABI, @functions.values.sample.abi)
  end

  ##
  # Checks that the object is of the given type, optionally raising an exception
  # if it is not.
  #
  # @param object [Object] The object to check.
  # @param type [Class] The class to ensure it either is or derives from.
  # @param exception [Boolean] Flag indicating if an exception should be raised
  #   in the event the object is not the correct type.
  # @return [Boolean] +true+ if object is of the specified type, otherwise
  #   *false*.
  # @raise [TypeError] when the type does not match and the exception parameter
  #   is +true+.
  def self.type?(object, type, exception = true)
    return true if object.is_a?(type)
    return false unless exception
    raise TypeError, "#{object} is not a #{type}."
  end

  ##
  # Checks whether the specified index falls within the given range, optionally
  #   raises an exception if it does not.
  #
  # @param index [Integer] The value to check.
  # @param min [Integer] The minimum valid value.
  # @param max [Integer] The maximum valid value.
  # @param exception [Boolean] Flag indicating if an exception should be raised
  #   in the event the value is not within the specified range.
  # @return [Boolean] +true+ if object is within specified range, otherwise
  #   *false*.
  # @raise [RangeError] when the value is out of range and the exception
  #   parameter is +true+.
  def self.valid_range?(index, min, max, exception = true)
    return true if index.between?(min, max)
    return false unless exception
    raise RangeError, "#{index} outside of valid range (#{min}..#{max})."
  end

  ##
  # Converts an integer value to a version string representation.
  # @param version [Integer] The version is a 32bit hexadecimal value formatted
  #   as 16:8:8, with the upper 16 bits being the major version, the middle
  #   8bits being the minor version and the bottom 8 bits being the development
  #   version. For example a value of 00040106h is equal to 4.01.06.
  # @return [String] the version string.
  def self.uint2version(version)
    version = version.unpack1('L') if version.is_a?(String)
    vs = "%08X" % version
    "#{vs[0, 4].to_i}.#{vs[4, 2].to_i}.#{vs[6, 2].to_i}"
  end
end
