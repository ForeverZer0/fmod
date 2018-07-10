module FMOD
  module Core

    ##
    # Sound description bit-fields, bitwise OR them together for loading and
    # describing sounds.
    module Mode

      ##
      # Default for all modes listed below. {LOOP_OFF}, {TWO_D},
      # {WORLD_RELATIVE_3D}, {INVERSE_ROLLOFF_3D}
      DEFAULT = 0x00000000

      ##
      # For non looping sounds. (DEFAULT). Overrides {LOOP_NORMAL} /
      # {LOOP_BIDI}.
      LOOP_OFF = 0x00000001

      ##
      # For forward looping sounds.
      LOOP_NORMAL=  0x00000002

      ##
      # For bidirectional looping sounds. (only works on software mixed static
      # sounds).
      LOOP_BIDI = 0x00000004

      ##
      # Ignores any 3D processing. ({DEFAULT}).
      TWO_D = 0x00000008

      ##
      # Makes the sound positionable in 3D. Overrides {TWO_D}.
      THREE_D = 0x00000010

      ##
      # Decompress at runtime, streaming from the source provided (ie from
      # disk). Overrides {CREATE_SAMPLE} and {CREATE_COMPRESSED_SAMPLE}. Note a
      # stream can only be played once at a time due to a stream only having 1
      # stream buffer and file handle. Open multiple streams to have them play
      # concurrently.
      CREATE_STREAM = 0x00000080

      ##
      # Decompress at load time, decompressing or decoding whole file into
      # memory as the target sample format (ie PCM). Fastest for playback and
      # most flexible.
      CREATE_SAMPLE = 0x00000100

      ##
      # Load MP2/MP3/FADPCM/IMAADPCM/Vorbis/AT9 or XMA into memory and leave it
      # compressed. Vorbis/AT9/FADPCM encoding only supported in the .FSB
      # container format. During playback the FMOD software mixer will decode it
      # in realtime as a 'compressed sample'. Overrides {CREATE_SAMPLE}. If the
      # sound data is not one of the supported formats, it will behave as if it
      # was created with {CREATE_SAMPLE} and decode the sound into PCM.
      CREATE_COMPRESSED_SAMPLE = 0x00000200

      ##
      # Opens a user created static sample or stream.
      OPEN_USER = 0x00000400

      ##
      # "source" will be interpreted as a pointer to memory instead of filename
      # for creating sounds. If used with {CREATE_SAMPLE} or
      # {CREATE_COMPRESSED_SAMPLE}, FMOD duplicates the memory into its own
      # buffers. Your own buffer can be freed after open. If used with
      # {CREATE_STREAM}, FMOD will stream out of the buffer whose pointer you
      # passed in. In this case, your own buffer should not be freed until you
      # have finished with and released the stream.
      OPEN_MEMORY = 0x00000800

      ##
      # "source" will be interpreted as a pointer to memory instead of filename
      # for creating sounds. This differs to {OPEN_MEMORY} in that it uses the
      # memory as is, without duplicating the memory into its own buffers.
      # Cannot be freed after open, only after Sound::release. Will not work if
      # the data is compressed and {CREATE_COMPRESSED_SAMPLE} is not used.
      OPEN_MEMORY_POINT = 0x10000000

      ##
      # Will ignore file format and treat as raw PCM.
      OPEN_RAW = 0x00001000

      ##
      # Just open the file, dont pre-buffer or read. Good for fast opens for
      # info, or when Sound.read_data is to be used.
      OPEN_ONLY = 0x00002000

      ##
      # For System.create_sound - for accurate Sound.length/Channel.position on
      # VBR MP3, and MOD/S3M/XM/IT/MIDI files. Scans file first, so takes longer
      # to open. {OPEN_ONLY} does not affect this.
      ACCURATE_TIME = 0x00004000

      ##
      # For corrupted / bad MP3 files. This will search all the way through the
      # file until it hits a valid MPEG header. Normally only searches for 4k.
      MPEG_SEARCH = 0x00008000

      ##
      # For opening sounds and getting streamed sub-sounds (seeking)
      # asynchronously. Use Sound.open_state to poll the state of the sound as
      # it opens or retrieves the sub-sound in the background.
      NON_BLOCKING = 0x00010000

      ##
      # Unique sound, can only be played one at a time
      UNIQUE = 0x00020000

      ##
      # Make the sound's position, velocity and orientation relative to the
      # listener.
      HEAD_RELATIVE_3D = 0x00040000

      ##
      # Make the sound's position, velocity and orientation absolute (relative
      # to the world). ({DEFAULT})
      WORLD_RELATIVE_3D = 0x00080000

      ##
      # This sound will follow the inverse rolloff model where min distance =
      # full volume, max distance = where sound stops attenuating, and rolloff
      # is fixed according to the global rolloff factor. ({DEFAULT})
      INVERSE_ROLLOFF_3D = 0x00100000

      ##
      # This sound will follow a linear rolloff model where min distance is full
      # volume, max distance is silence.
      LINEAR_ROLLOFF_3D = 0x00200000

      ##
      # This sound will follow a linear-square rolloff model where min distance
      # is full volume, max distance is silence.
      LINEAR_SQUARE_ROLLOFF_3D = 0x00400000

      ##
      # This sound will follow the inverse rolloff model at distances close to
      # min distance and a linear-square rolloff close to max distance.
      INVERSE_TAPERED_ROLLOFF_3D = 0x00800000

      ##
      # is sound will follow a rolloff model defined by Sound.custom_rolloff /
      # Channel.custom_rolloff.
      CUSTOM_ROLLOFF_3D = 0x04000000

      ##
      # Is not affect by geometry occlusion. If not specified in Sound:.mode, or
      # Channel.mode, the flag is cleared and it is affected by geometry again.
      IGNORE_GEOMETRY_3D = 0x40000000

      ##
      # Skips id3v2/asf/etc tag checks when opening a sound, to reduce seek/read
      # overhead when opening files (helps with CD performance).
      IGNORE_TAGS = 0x02000000

      ##
      # Removes some features from samples to give a lower memory overhead, like
      # Sound.name.
      LOW_MEM = 0x08000000

      ##
      # Load sound into the secondary RAM of supported platform. On PS3, sounds
      # will be loaded into RSX/VRAM.
      LOAD_SECONDARY_RAM = 0x20000000

      ##
      # For sounds that start virtual (due to being quiet or low importance),
      # instead of swapping back to audible, and playing at the correct offset
      # according to time, this flag makes the sound play from the start.
      VIRTUAL_PLAY_FROM_START = 0x80000000
    end
  end
end