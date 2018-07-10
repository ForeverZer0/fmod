require 'fiddle'

module FMOD
  module Core
    class Structure < Fiddle::CStructEntity

      include Fiddle
      include FMOD::Core

      def initialize(address, types, members)
        address = Pointer[address] if address.is_a?(String)
        address ||= Fiddle.malloc(self.class.size(types)).to_i
        super(address, types)
        assign_names members
      end

      def names
        @members
      end

      def values
        @members.map { |sym| self[sym] }
      end

      def inspect
        values = @members.map { |sym| "#{sym}=#{self[sym]}"}.join(', ')
        super.sub(/free=0x(.)*/, values << '>')
      end
    end
  end
end