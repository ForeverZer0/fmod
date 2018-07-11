module FMOD
  module Core

    ##
    # Structure describing a piece of tag data.
    class Tag < Structure

      include Fiddle

      ##
      # Strings for ID3v1 tags that use a number to represent the genre. That
      # number can be used as an index into this array to retrieve the name for
      # the genre.
      #
      # @since 0.9.2
      ID3V1_GENRES = %w[
        Blues Classic\ Rock Country Dance Disco Funk Grunge Hip-Hop Jazz Metal
        New\ Age Oldies Other Pop R&B Rap Reggae Rock Techno Industrial
        Alternative Ska Death\ Metal Pranks Soundtrack Euro-Techno Ambient
        Trip-Hop Vocal Jazz+Funk Fusion Trance Classical Instrumental Acid House
        Game Sound\ Clip Gospel Noise Alternative\ Rock Bass Soul Punk Space
        Meditative Instrumental\ Pop Instrumental\ Rock Ethnic Gothic Darkwave
        Techno-Industrial Electronic Pop-Folk Eurodance Dream Southern\ Rock
        Comedy Cult Gangsta Top\ 40 Christian\ Rap Pop/Funk Jungle Native\
        American Cabaret New\ Wave Psychedelic Rave Showtunes Trailer Lo-Fi
        Tribal Acid\ Punk Acid\ Jazz Polka Retro Musical Rock\ &\ Roll Hard\
        Rock Folk Folk/Rock National\ Folk Swing Fusion Bebob Latin Revival
        Celtic Bluegrass Avantgarde Gothic\ Rock Progressive\ Rock Psychedelic\
        Rock Symphonic\ Rock Slow\ Rock Big\ Band Chorus Easy\ Listening
        Acoustic Humour Speech Chanson Opera Chamber\ Music Sonata Symphony
        Booty\ Bass Primus Porn\ Groove Satire Slow\ Jam Club Tango Samba
        Folklore Ballad Power\ Ballad Rhythmic\ Soul Freestyle Duet Punk\ Rock
        Drum\ Solo A\ Cappella Euro-House Dance\ Hall Goa Drum\ &\ Bass
        Club-House Hardcore Terror Indie BritPop Negerpunk Polsk\ Punk Beat
        Christian\ Gangsta\ Rap Heavy\ Metal Black\ Metal Crossover
        Contemporary\ Christian Christian\ Rock Merengue Salsa Thrash\ Metal
        Anime Jpop Synthpop Abstract Art\ Rock Baroque Bhangra Big\ Beat
        Breakbeat Chillout Downtempo Dub EBM Eclectic Electro Electroclash Emo
        Experimental Garage Global IDM Illbient Industro-Goth Jam\ Band
        Krautrock Leftfield Lounge Math\ Rock New\ Romantic Nu-Breakz Post-Punk
        Post-Rock Psytrance Shoegaze Space\ Rock Trop\ Rock World\ Music
        Neoclassical Audiobook Audio\ Theatre Neue\ Deutsche\ Welle Podcast
        Indie-Rock G-Funk Dubstep Garage\ Rock Psybient
      ].freeze

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_INT]
        members = [:type, :data_type, :name, :data, :data_length, :updated]
        super(address, types, members)
      end

      ##
      # @!attribute [r] type
      # @return [Integer] the type of this tag.
      #   @see TagType

      ##
      # @!attribute [r] data_type
      # @return [Integer] the type of data that this tag contains.
      #   @see TagDataType

      ##
      # @!attribute [r] data_length
      # @return [Integer] the length of the data contained in this tag in bytes.

      [:type, :data_type, :data_length].each do |symbol|
        define_method(symbol) { self[symbol] }
      end

      ##
      # @!attribute [r] name
      # @return [String] the name of this tag i.e. "TITLE", "ARTIST" etc.
      def name
        self[:name].to_s
      end

      ##
      # @return [Boolean] a flag indicating if this tag has been updated sinc
      #   last being accessed.
      def updated?
        self[:updated] != 0
      end

      ##
      # Retrieves the tag data, which can vary depending on the value specified
      # in {#data_type}.
      # @return [String, Float, Integer] the tag data.
      # @see TagDataType
      def value
        raw = self[:data].to_s(self[:data_length])
        raw.delete!("\0") unless self[:data_type] == TagDataType::BINARY
        # noinspection RubyResolve
        case self[:data_type]
        when TagDataType::BINARY then raw
        when TagDataType::INT then raw.unpack1('l')
        when TagDataType::FLOAT then raw.unpack1('f')
        when TagDataType::STRING then raw.force_encoding('ASCII')
        when TagDataType::STRING_UTF8 then raw.force_encoding(Encoding::UTF_8)
        when TagDataType::STRING_UTF16 then raw.force_encoding(Encoding::UTF_16)
        when TagDataType::STRING_UTF16BE then raw.force_encoding(Encoding::UTF_16BE)
        else ''
        end
      end
    end
  end
end


