module FMOD
  module Core
    class IntegerDescription < Structure

      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, TYPE_INT, TYPE_INT, TYPE_VOIDP]
        members = [:min, :max, :default, :infinite, :names]
        super(address, types, members)
      end

      [:min, :max, :default].each do |symbol|
        define_method(symbol) { self[symbol] }
      end

      def infinite
        self[:infinite] != 0
      end

      def names
        return [] if self[:names].null?
        count = max - min + 1
        (0...count).map { |i| (self[:names] + (i * SIZEOF_INTPTR_T)).ptr.to_s }
      end
    end
  end
end