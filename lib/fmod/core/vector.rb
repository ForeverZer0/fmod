module FMOD
  module Core

    ##
    # Structure describing a point in 3D space.
    class Vector < Structure

      ##
      # @return [Vector] a new {Vector} with all values set to 0.0.
      def self.zero
        new(0.0, 0.0, 0.0)
      end

      ##
      # @return [Vector] a new {Vector} with all values set to 1.0.
      def self.one
        new(1.0, 1.0, 1.0)
      end

      ##
      # @overload initialize(address)
      #   @param address [Pointer, Integer, String, nil] The address in memory
      #     where the structure will be created from. If no address is given,
      #     new memory will be allocated.
      # @overload initialize(x, y, z)
      #   @param x [Float] The X coordinate in 3D space.
      #   @param y [Float] The Y coordinate in 3D space.
      #   @param z [Float] The Z coordinate in 3D space.
      def initialize(*args)
        address ||= args.size == 1 ? args.first : nil
        members = [:x, :y, :z]
        types = Array.new(3, TYPE_FLOAT)
        super(address, types, members)
        set(*args) if args.size == 3
      end

      # @!attribute x
      # @return [Float] the X coordinate in 3D space.

      # @!attribute y
      # @return [Float] the Y coordinate in 3D space.

      # @!attribute z
      # @return [Float] the Z coordinate in 3D space.

      [:x, :y, :z].each do |symbol|
        define_method(symbol) { self[symbol] }
        define_method("#{symbol}=") { |value| self[symbol] = value.to_f }
      end

      ##
      # Helper function to set the {#x}, {#y}, and {#z} values simultaneously.
      #
      # @param x [Float] The X coordinate in 3D space.
      # @param y [Float] The Y coordinate in 3D space.
      # @param z [Float] The Z coordinate in 3D space.
      #
      # @return [self]
      def set(x, y, z)
        self[:x], self[:y], self[:z] = x, y, z
        self
      end

      ##
      # @return [Array(Float, Float, Float)] the result of interpreting the
      #   vector as an Array.
      def to_a
        @members.map { |sym| self[sym] }
      end

      ##
      # @return [Hash<Symbol, Float>] the result of interpreting the vector as a
      #   Hash.
      def to_h
        { x: self[:x], y: self[:y], z: self[:z] }
      end
    end
  end
end