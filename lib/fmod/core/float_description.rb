module FMOD
  module Core
    class FloatDescription < Structure

      def initialize(address = nil)
        types = [TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT, TYPE_INT]
        members = [:min, :max, :default, :mapping]
        super(address, types, members)
      end

      [:min, :max, :default, :mapping].each do |symbol|
        define_method(symbol) { self[symbol] }
      end
    end
  end
end