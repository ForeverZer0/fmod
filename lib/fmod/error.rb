module FMOD
  class Error < StandardError

    include FMOD::Core

    ##
    # @overload initialize(code)
    #   @param code [Integer]
    # @overload initialize(message)
    #   @param message [String]
    def initialize(code)
      message = code.is_a?(Integer) ? self.class.error_string(code) : code
      super(message)
    end

    ##
    # Retrieves a generic message for the specified result code.
    # @param code [Integer] An FMOD generated error code.
    # @return [String] A generic error message.
    # @see Result
    def self.error_string(code)
      case code
      when Result::BAD_COMMAND then "Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound)."
      when Result::CHANNEL_ALLOC then "Error trying to allocate a channel."
      when Result::CHANNEL_STOLEN then "The specified channel has been reused to play another sound."
      when Result::DMA then "DMA Failure. See debug output for more information."
      when Result::DSP_CONNECTION then "DSP connection error. Connection possibly caused a cyclic dependency or connected dsps with incompatible buffer counts."
      when Result::DSP_DONT_PROCESS then "DSP return code from a DSP process query callback. Tells mixer not to call the process callback and therefore not consume CPU. Use this to optimize the DSP graph. "
      when Result::DSP_FORMAT then "DSP Format error. A DSP unit may have attempted to connect to this network with the wrong format, or a matrix may have been set with the wrong size if the target unit has a specified channel map."
      when Result::DSP_IN_USE then "DSP is already in the mixer's DSP network. It must be removed before being reinserted or released."
      when Result::DSP_NOT_FOUND then "DSP connection error. Couldn't find the DSP unit specified."
      when Result::DSP_RESERVED then "DSP operation error. Cannot perform operation on this DSP as it is reserved by the system."
      when Result::DSP_SILENCE then "DSP return code from a DSP process query callback. Tells mixer silence would be produced from read, so go idle and not consume CPU. Use this to optimize the DSP graph."
      when Result::DSP_TYPE then "DSP operation cannot be performed on a DSP of this type. "
      when Result::FILE_BAD then "Error loading file."
      when Result::FILE_COULD__SEEK then "Couldn't perform seek operation. This is a limitation of the medium (ie netstreams) or the file format."
      when Result::FILE_DISK_EJECTED then "Media was ejected while reading."
      when Result::FILE_EOF then "End of file unexpectedly reached while trying to read essential data (truncated?)."
      when Result::FILE_END_OF_DATA then "End of current chunk reached while trying to read data. "
      when Result::FILE_NOT_FOUND then "File not found."
      when Result::FORMAT then "Unsupported file or audio format."
      when Result::HEADER_MISMATCH then "There is a version mismatch between the FMOD header and either the FMOD Studio library or the FMOD Low Level library."
      when Result::HTTP then " HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere."
      when Result::HTTP_ACCESS then "The specified resource requires authentication or is forbidden."
      when Result::HTTP_PROXY_AUTH then "Proxy authentication is required to access the specified resource. "
      when Result::HTTP_SERVER_ERROR then "A HTTP server error occurred."
      when Result::HTTP_TIMEOUT then "The HTTP request timed out. "
      when Result::INITIALIZATION then "FMOD was not initialized correctly to support this function. "
      when Result::INITIALIZED then "Cannot call this command after System::new."
      when Result::INTERNAL then "An error occurred that wasn't supposed to. Contact support."
      when Result::INVALID_FLOAT then "Value passed in was a NaN, Inf or denormalized float."
      when Result::INVALID_HANDLE then "An invalid object handle was used."
      when Result::INVALID_PARAM then "An invalid parameter was passed to this function."
      when Result::INVALID_POSITION then "An invalid seek position was passed to this function."
      when Result::INVALID_SPEAKER then "An invalid speaker was passed to this function based on the current speaker mode. "
      when Result::INVALID_SYNC_POINT then "The syncpoint did not come from this sound handle."
      when Result::INVALID_THREAD then "Tried to call a function on a thread that is not supported."
      when Result::INVALID_VECTOR then "The vectors passed in are not unit length, or perpendicular."
      when Result::MAX_AUDIBLE then "Reached maximum audible playback count for this sound's soundgroup."
      when Result::MEMORY then "Not enough memory or resources."
      when Result::MEMORY_CANT_POINT then "Can't use OPEN_MEMORY_POINT on non-PCM source data, or non mp3/xma/adpcm data if CREATE_COMPRESSED_SAMPLE was used."
      when Result::NEEDS_3D then "Tried to call a command on a 2d sound when the command was meant for 3d sound."
      when Result::NEEDS_HARDWARE then "Tried to use a feature that requires hardware support."
      when Result::NET_CONNECT then "Couldn't connect to the specified host."
      when Result::NET_SOCKET_ERROR then "A socket error occurred. This is a catch-all for socket-related errors not listed elsewhere."
      when Result::NET_URL then "The specified URL couldn't be resolved."
      when Result::NET_WOULD_BLOCK then "Operation on a non-blocking socket could not complete immediately. "
      when Result::NOT_READY then "Operation could not be performed because specified sound/DSP connection is not ready."
      when Result::OUTPUT_ALLOCATED then "Error initializing output device, but more specifically, the output device is already in use and cannot be reused."
      when Result::OUTPUT_CREATE_BUFFER then "Error creating hardware sound buffer."
      when Result::OUTPUT_DRIVER_CALL then "A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted."
      when Result::OUTPUT_FORMAT then "Soundcard does not support the specified format."
      when Result::OUTPUT_INIT then "Error initializing output device."
      when Result::OUTPUT_NO_DRIVERS then "The output device has no drivers installed. If pre-init, OUTPUT_NO_SOUND is selected as the output mode. If post-init, the function just fails."
      when Result::PLUGIN then "An unspecified error has been returned from a plugin."
      when Result::PLUGIN_MISSING then "A requested output, dsp unit type or codec was not available."
      when Result::PLUGIN_RESOURCE then "A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback)"
      when Result::PLUGIN_VERSION then "A plugin was built with an unsupported SDK version."
      when Result::RECORD then "An error occurred trying to initialize the recording device."
      when Result::REVERB_CHANNEL_GROUP then "Reverb properties cannot be set on this channel because a parent channelgroup owns the reverb connection."
      when Result::REVERB_INSTANCE then "Specified instance in ReverbProperties couldn't be set. Most likely because it is an invalid instance number or the reverb doesn't exist"
      when Result::SUBSOUNDS then "The error occurred because the sound referenced contains subsounds when it shouldn't have, or it doesn't contain subsounds when it should have. The operation may also not be able to be performed on a parent sound."
      when Result::SUBSOUND_ALLOCATED then "This subsound is already being used by another sound, you cannot have more than one parent to a sound. Null out the other parent's entry first."
      when Result::SUBSOUND_CANT_MOVE then "Shared subsounds cannot be replaced or moved from their parent stream, such as when the parent stream is an FSB file."
      when Result::TAG_NOT_FOUND then "The specified tag could not be found or there are no tags."
      when Result::TOO_MANY_CHANNELS then "The sound created exceeds the allowable input channel count. This can be increased using the 'maxinputchannels' parameter in System::setSoftwareFormat."
      when Result::TRUNCATED then "The retrieved string is too long to fit in the supplied buffer and has been truncated."
      when Result::UNIMPLEMENTED then "Something in FMOD hasn't been implemented when it should be! contact support!"
      when Result::UNINITIALIZED then "This command failed because System::new or System::set_driver was not called."
      when Result::UNSUPPORTED then "A command issued was not supported by this object. Possibly a plugin without certain callbacks specified"
      when Result::VERSION then "The version number of this file format is not supported."
      when Result::EVENT_ALREADY_LOADED then "The specified bank has already been loaded."
      when Result::EVENT_LIVE_UPDATE_BUSY then "The live update connection failed due to the game already being connected."
      when Result::EVENT_LIVE_UPDATE_MISMATCH then "The live update connection failed due to the game data being out of sync with the tool."
      when Result::EVENT_LIVE_UPDATE_TIMEOUT then "The live update connection timed out."
      when Result::EVENT_NOT_FOUND then "The requested event, bus or vca could not be found."
      when Result::STUDIO_UNINITIALIZED then "The Studio::System object is not yet initialized."
      when Result::STUDIO_NOT_LOADED then "The specified resource is not loaded, so it can't be unloaded."
      when Result::INVALID_STRING then "An invalid string was passed to this function."
      when Result::ALREADY_LOCKED then "The specified resource is already locked."
      when Result::NOT_LOCKED then "The specified resource is not locked, so it can't be unlocked."
      when Result::RECORD_DISCONNECTED then "The specified recording driver has been disconnected."
      when Result::TOO_MANY_SAMPLES then "The length provided exceeds the allowable limit."
      else "Unknown error. Code: #{code}"
      end
    end
  end
end