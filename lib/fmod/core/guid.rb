

module FMOD
  module Core

    ##
    # Structure describing a globally unique identifier.
    class Guid < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = [TYPE_INT, TYPE_SHORT, TYPE_SHORT, [TYPE_CHAR, 8]]
        members = [:data1, :data2, :data3, :data4]
        super(address, types, members)
      end

      ##
      # @return [Integer] the first 8 hexadecimal digits of the GUID.
      def data1
        [self[:data1]].pack('l').unpack1('L')
      end

      ##
      # @return [Integer] the first group of 4 hexadecimal digits.
      def data2
        [self[:data2]].pack('s').unpack1('S')
      end

      ##
      # @return [Integer] the second group of 4 hexadecimal digits.
      def data3
        [self[:data3]].pack('s').unpack1('S')
      end

      ##
      # Array of 8 bytes. The first 2 bytes contain the third group of 4
      # hexadecimal digits. The remaining 6 bytes contain the final 12.
      #
      # hexadecimal digits.
      # @return [Array<Integer>] the last part if the GUID.
      def data4
        self[:data4].pack('c*').unpack('C*')
      end

      ##
      # @return [Boolean] +true+ if objects are equal, otherwise +false+.
      # @param obj [Object] The object to compare.
      def eql?(obj)
        if obj.is_a?(Guid)
          return false unless data1 == obj.data1
          return false unless data2 == obj.data2
          return false unless data3 == obj.data3
          return data4 == obj.data4
        end
        to_s.tr('-', '').casecmp(obj.to_s.tr('-', '')).zero?
      end

      ##
      # @return [Boolean] +true+ if objects are equal, otherwise +false+.
      # @param obj [Object] The object to compare.
      def ==(obj)
        eql?(obj)
      end

      ##
      # @return [String] the string representation of the GUID.
      def to_s
        d4 = data4
        last = d4[2, 6].map { |byte| "%02X" % byte }.join
        "%08X-%04X-%04X-%02X%02X-#{last}" % [data1, data2, data3, d4[0], d4[1]]
      end
    end
  end
end