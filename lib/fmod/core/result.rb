module FMOD
  module Core

    ##
    # Result codes returned from every function call to FMOD.
    module Result
      ##
      # No errors.
      OK = 0

      ##
      # Tried to call a function on a data type that does not allow this type of
      # functionality (ie calling {Sound.lock} on a streaming sound).
      BAD_COMMAND = 1

      ##
      # Error trying to allocate a channel.
      CHANNEL_ALLOC = 2

      ##
      # The specified channel has been reused to play another sound.
      CHANNEL_STOLEN = 3

      ##
      # DMA Failure. See debug output for more information.
      DMA = 4

      ##
      # DSP connection error. Connection possibly caused a cyclic dependency or
      # connected dsps with incompatible buffer counts.
      DSP_CONNECTION = 5

      ##
      # DSP return code from a DSP process query callback. Tells mixer not to
      # call the process callback and therefore not consume CPU. Use this to
      # optimize the DSP graph.
      DSP_DONT_PROCESS = 6

      ##
      # DSP Format error. A DSP unit may have attempted to connect to this
      # network with the wrong format, or a matrix may have been set with the
      # wrong size if the target unit has a specified channel map.
      DSP_FORMAT = 7

      ##
      # DSP is already in the mixer's DSP network. It must be removed before
      # being reinserted or released.
      DSP_IN_USE = 8

      ##
      # DSP connection error. Couldn't find the DSP unit specified.
      DSP_NOT_FOUND = 9

      ##
      # DSP operation error. Cannot perform operation on this DSP as it is
      # reserved by the system.
      DSP_RESERVED = 10

      ##
      # DSP return code from a DSP process query callback. Tells mixer silence
      # would be produced from read, so go idle and not consume CPU. Use this to
      # optimize the DSP graph.
      DSP_SILENCE = 11

      ##
      # DSP operation cannot be performed on a DSP of this type.
      DSP_TYPE = 12

      ##
      # Error loading file.
      FILE_BAD = 13

      ##
      # Couldn't perform seek operation. This is a limitation of the medium (ie
      # net-streams) or the file format.
      FILE_COULD__SEEK = 14

      ##
      # Media was ejected while reading.
      FILE_DISK_EJECTED = 15

      ##
      # End of file unexpectedly reached while trying to read essential data
      # (truncated?).
      FILE_EOF = 16

      ##
      # End of current chunk reached while trying to read data.
      FILE_END_OF_DATA = 17

      ##
      # File not found.
      FILE_NOT_FOUND = 18

      ##
      # Unsupported file or audio format.
      FORMAT = 19

      ##
      # There is a version mismatch between the FMOD header and either the FMOD
      # Studio library or the FMOD Low Level library.
      HEADER_MISMATCH = 20

      ##
      # A HTTP error occurred. This is a catch-all for HTTP errors not listed
      # elsewhere.
      HTTP = 21

      ##
      # The specified resource requires authentication or is forbidden.
      HTTP_ACCESS = 22

      ##
      # Proxy authentication is required to access the specified resource.
      HTTP_PROXY_AUTH = 23

      ##
      # A HTTP server error occurred.
      HTTP_SERVER_ERROR = 24

      ##
      # The HTTP request timed out.
      HTTP_TIMEOUT = 25

      ##
      # FMOD was not initialized correctly to support this function.
      INITIALIZATION = 26

      ##
      # Cannot call this command after FMOD::System.create.
      INITIALIZED = 27

      ##
      # An error occurred that wasn't supposed to. Contact support.
      INTERNAL = 28

      ##
      # Value passed in was a NaN, Inf or de-normalized float.
      INVALID_FLOAT = 29

      ##
      # An invalid object handle was used.
      INVALID_HANDLE = 30

      ##
      # An invalid parameter was passed to a function.
      INVALID_PARAM = 31

      ##
      # An invalid seek position was passed to a function.
      INVALID_POSITION = 32

      ##
      # An invalid speaker was passed to this function based on the current
      # speaker mode.
      INVALID_SPEAKER = 33

      ##
      # The syncpoint did not come from this sound handle.
      INVALID_SYNC_POINT = 34

      ##
      # Tried to call a function on a thread that is not supported.
      INVALID_THREAD = 35

      ##
      # The vectors passed in are not unit length, or perpendicular.
      INVALID_VECTOR = 36

      ##
      # Reached maximum audible playback count for this sound's sound group.
      MAX_AUDIBLE = 37

      ##
      # Not enough memory or resources.
      MEMORY = 38

      ##
      # Can't use "open memory point" on non PCM source data, or non
      # mp3/xma/adpcm data if "create compressed sample" was used.
      MEMORY_CANT_POINT = 39

      ##
      # Tried to call a command on a 2d sound when the command was meant for 3D
      # sound.
      NEEDS_3D = 40

      ##
      # Tried to use a feature that requires hardware support.
      NEEDS_HARDWARE = 41

      ##
      # Couldn't connect to the specified host.
      NET_CONNECT = 42

      ##
      # A socket error occurred. This is a catch-all for socket-related errors
      # not listed elsewhere.
      NET_SOCKET_ERROR = 43

      ##
      # The specified URL couldn't be resolved.
      NET_URL = 44

      ##
      # Operation on a non-blocking socket could not complete immediately.
      NET_WOULD_BLOCK = 45

      ##
      # Operation could not be performed because specified sound/DSP connection
      # is not ready.
      NOT_READY = 46

      ##
      # Error initializing output device, but more specifically, the output
      # device is already in use and cannot be reused.
      OUTPUT_ALLOCATED = 47

      ##
      # Error creating hardware sound buffer.
      OUTPUT_CREATE_BUFFER = 48

      ##
      # A call to a standard soundcard driver failed, which could possibly mean
      # a bug in the driver or resources were missing or exhausted.
      OUTPUT_DRIVER_CALL = 49

      ##
      # Sound card does not support the specified format.
      OUTPUT_FORMAT = 50

      ##
      # Error initializing output device.
      OUTPUT_INIT = 51

      ##
      # The output device has no drivers installed. If pre-init, NO_SOUND is
      # selected as the output mode. If post-init, the function just fails.
      OUTPUT_NO_DRIVERS = 52

      ##
      # An unspecified error has been returned from a plugin.
      PLUGIN = 53

      ##
      # A requested output, DSP unit type or codec was not available.
      PLUGIN_MISSING = 54

      ##
      # A resource that the plugin requires cannot be found. (ie the DLS file
      # for MIDI playback)
      PLUGIN_RESOURCE = 55

      ##
      # A plugin was built with an unsupported SDK version.
      PLUGIN_VERSION = 56

      ##
      # An error occurred trying to initialize the recording device.
      RECORD = 57

      ##
      # Reverb properties cannot be set on this channel because a parent channel
      # group owns the reverb connection.
      REVERB_CHANNEL_GROUP = 58

      ##
      # Specified instance in Reverb couldn't be set. Most likely because it is
      # an invalid instance number or the reverb doesn't exist.
      REVERB_INSTANCE = 59

      ##
      # The error occurred because the sound referenced contains sub-sounds when
      # it shouldn't have, or it doesn't contain sub-sounds when it should have.
      # The operation may also not be able to be performed on a parent sound.
      SUBSOUNDS = 60

      ##
      # This subsound is already being used by another sound, you cannot have
      # more than one parent to a sound. Null out the other parent's entry
      # first.
      SUBSOUND_ALLOCATED = 61

      ##
      # Shared subsounds cannot be replaced or moved from their parent stream,
      # such as when the parent stream is an FSB file.
      SUBSOUND_CANT_MOVE = 62

      ##
      # The specified tag could not be found or there are no tags.
      TAG_NOT_FOUND = 63

      ##
      # The sound created exceeds the allowable input channel count.
      TOO_MANY_CHANNELS = 64

      ##
      # The retrieved string is too long to fit in the supplied buffer and has
      # been truncated.
      TRUNCATED = 65

      ##
      # Something in FMOD hasn't been implemented when it should be! Contact
      # support!
      UNIMPLEMENTED = 66

      ##
      # This command failed because System.create or System.output was not
      # called.
      UNINITIALIZED = 67

      ##
      # A command issued was not supported by this object. Possibly a plugin
      # without certain callbacks specified.
      UNSUPPORTED = 68

      ##
      # The version number of this file format is not supported.
      VERSION = 69

      ##
      # The specified bank has already been loaded.
      EVENT_ALREADY_LOADED = 70

      ##
      # The live update connection failed due to the game already being
      # connected.
      EVENT_LIVE_UPDATE_BUSY = 71

      ##
      # The live update connection failed due to the game data being out of sync
      # with the tool.
      EVENT_LIVE_UPDATE_MISMATCH = 72

      ##
      # The live update connection timed out.
      EVENT_LIVE_UPDATE_TIMEOUT = 73

      ##
      # The requested event, bus or vca could not be found.
      EVENT_NOT_FOUND = 74

      ##
      # The Studio::System object is not yet initialized.
      STUDIO_UNINITIALIZED = 75

      ##
      # The specified resource is not loaded, so it can't be unloaded.
      STUDIO_NOT_LOADED = 76

      ##
      # An invalid string was passed to this function.
      INVALID_STRING = 77

      ##
      # The specified resource is already locked.
      ALREADY_LOCKED = 78

      ##
      # The specified resource is not locked, so it can't be unlocked.
      NOT_LOCKED = 79

      ##
      # The specified recording driver has been disconnected.
      RECORD_DISCONNECTED = 80

      ##
      # The length provided exceeds the allowable limit.
      TOO_MANY_SAMPLES = 81
    end
  end
end