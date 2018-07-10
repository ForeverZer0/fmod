module FMOD
  module Core
    class Tag < Structure

      include Fiddle

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, TYPE_VOIDP, TYPE_VOIDP, TYPE_INT, TYPE_INT]
        members = [:type, :data_type, :name, :data, :data_length, :updated]
        super(address, types, members)
      end

      [:type, :data_type, :data_length].each do |symbol|
        define_method(symbol) { self[symbol] }
      end

      def name
        self[:name].to_s
      end

      def updated
        self[:updated] != 0
      end

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

      def to_s
        begin
          "#{value}"
        rescue Encoding::CompatibilityError
          value.inspect
          # TODO
        end
      end
    end
  end
end