module FMOD
  module Core
    # @attr x [Float]
    # @attr y [Float]
    # @attr z [Float]
    class Vector < Structure

      def self.zero
        new(0.0, 0.0, 0.0)
      end

      def self.one
        new(1.0, 1.0, 1.0)
      end

      def initialize(*args)
        address ||= args.size == 1 ? args.first : nil
        members = [:x, :y, :z]
        types = Array.new(3, TYPE_FLOAT)
        super(address, types, members)
        set(*args) if args.size == 3
      end

      [:x, :y, :z].each do |symbol|
        define_method(symbol) { self[symbol] }
        define_method("#{symbol}=") { |value| self[symbol] = value.to_f }
      end

      def set(x, y, z)
        self[:x], self[:y], self[:z] = x, y, z
      end

      def to_a
        @members.map { |sym| self[sym] }
      end

      def to_h
        { x: self[:x], y: self[:y], z: self[:z] }
      end
    end
  end
end