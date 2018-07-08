
require 'fiddle'
require 'fiddle/import'

module FMOD

  module Core

    WetDryMix = Struct.new(:pre_wet, :post_wet, :dry)

    LoopPoints = Struct.new(:start, :start_unit, :end, :end_unit)

    FadePoint = Struct.new(:clock, :volume)

    ##
    # Defines the sound projection cone including the volume when outside the
    # cone.
    #
    # @attr inside_angle [Float] Inside cone angle, in degrees. This is the
    #   angle within which the sound is at its normal volume.
    #
    #   Must not be greater than {#outside_angle}.
    #   * *Default:* 360.0
    # @attr outside_angle [Float] Outside cone angle, in degrees. This is the
    #   angle outside of which the sound is at its outside volume.
    #
    #   Must not be less than {#inside_angle}.
    #   * *Default:* 360.0
    # @attr outside_volume [Float] Cone outside volume.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 1.0
    #   * *Default:* 1.0
    ConeSettings = Struct.new(:inside_angle, :outside_angle, :outside_volume)

    class Structure < Fiddle::CStructEntity

      include Fiddle
      include FMOD::Core

      def initialize(address, types, members)
        address = Pointer[address] if address.is_a?(String)
        address ||= Fiddle.malloc(self.class.size(types)).to_i
        super(address, types)
        assign_names members
      end

      def inspect
        values = @members.map { |sym| "#{sym}=#{self[sym]}"}.join(', ')
        super.sub(/free=0x(.)*/, values << '>')
      end
    end

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

    class Tag < Structure

      include Fiddle

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

    class SpectrumData < Structure

      def initialize(address = nil)
        types = [TYPE_INT, TYPE_INT, [TYPE_FLOAT, 32]]
        members = [:length, :channel_count, :spectrum]
        super(address, types, members)
      end
    end

    class ParameterInfo < Structure

      include Fiddle

      def initialize(address = nil)
        types = [TYPE_INT, [TYPE_CHAR, 16], [TYPE_CHAR, 16], TYPE_VOIDP, TYPE_VOIDP]
        members = [:type, :name, :label, :description, :info]
        super(address, types, members)
      end

      def type
        self[:type]
      end

      def name
        (self + SIZEOF_INT).to_s(16).delete("\0").force_encoding('UTF-8')
      end

      def label
        (self + SIZEOF_INT + 16).to_s(16).delete("\0")
      end

      def description
        self[:description].to_s
      end

      def info
        pointer = self + SIZEOF_INT + (SIZEOF_CHAR * 32) + SIZEOF_INTPTR_T
        case self[:type]
        when ParameterType::FLOAT then FloatDescription.new(pointer)
        when ParameterType::INT then IntegerDescription.new(pointer)
        when ParameterType::BOOL then BoolDescription.new(pointer)
        when ParameterType::DATA then DataDescription.new(pointer)
        else raise RangeError, "Invalid data type for parameter."
        end
      end
    end

    class DataDescription < Structure

      def initialize(address = nil)
        super(address, [TYPE_INT], [:data_type])
      end

      def data_type
        self[:data_type]
      end
    end

    class BoolDescription < Structure

      def initialize(address = nil)
        super(address, [TYPE_INT, TYPE_VOIDP], [:default, :names])
      end

      def default
        self[:default] != 0
      end

      def names
        %w(true false)
      end
    end

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

    ##
    # Structure defining a reverb environment.
    # @attr decay_time [Float]
    # @attr early_delay [Float]
    # @attr late_delay [Float]
    # @attr hf_reference [Float]
    # @attr hf_decay_ratio [Float]
    # @attr diffusion [Float]
    # @attr density [Float]
    # @attr low_shelf_freq [Float]
    # @attr low_shelf_gain [Float]
    # @attr high_cut [Float]
    # @attr early_late_mix [Float]
    # @attr wet_level [Float]
    class Reverb < Structure

      def initialize(address = nil)
        types = Array.new(12, TYPE_FLOAT)
        members = [:decay_time, :early_delay, :late_delay,
          :hf_reference, :hf_decay_ratio, :diffusion, :density, :low_shelf_freq,
          :low_shelf_gain, :high_cut, :early_late_mix, :wet_level]
        super(address, types, members)
      end

      [:decay_time, :early_delay, :late_delay, :hf_reference, :hf_decay_ratio,
        :diffusion, :density, :low_shelf_freq, :low_shelf_gain, :high_cut,
        :early_late_mix, :wet_level].each do |symbol|
        define_method(symbol) { self[symbol] }
      end

      def decay_time=(value)
        self[:decay_time] = value.clamp(0.0, 20000.0)
      end

      def early_delay=(value)
        self[:early_delay] = value.clamp(0.0, 300.0)
      end

      def late_delay=(value)
        self[:late_delay] = value.clamp(0.0, 100.0)
      end

      def hf_reference=(value)
        self[:hf_reference] = value.clamp(20.0, 20000.0)
      end

      def hf_decay_ratio=(value)
        self[:hf_decay_ratio] = value.clamp(10.0, 100.0)
      end

      def diffusion=(value)
        self[:diffusion] = value.clamp(0.0, 100.0)
      end

      def density=(value)
        self[:density] = value.clamp(0.0, 100.0)
      end

      def low_shelf_freq=(value)
        self[:low_shelf_freq] = value.clamp(20.0, 1000.0)
      end

      def low_shelf_gain=(value)
        self[:low_shelf_gain] = value.clamp(-36.0, 12.0)
      end

      def high_cut=(value)
        self[:high_cut] = value.clamp(20.0, 20000.0)
      end

      def early_late_mix=(value)
        self[:early_late_mix] = value.clamp(0.0, 100.0)
      end

      def wet_level=(value)
        self[:wet_level] = value.clamp(-80.0, 20.0)
      end

      def self.off
        new [1000, 7, 11, 5000, 100, 100, 100, 250, 0, 20, 96, -80.0].pack('f*')
      end

      def self.generic
        new [1500, 7, 11, 5000, 83, 100, 100, 250, 0, 14500, 96, -8.0].pack('f*')
      end

      def self.padded_cell
        new [170, 1, 2, 5000, 10, 100, 100, 250, 0, 160, 84, -7.8].pack('f*')
      end

      def self.room
        new [400, 2, 3, 5000, 83, 100, 100, 250, 0, 6050, 88, -9.4].pack('f*')
      end

      def self.bathroom
        new [1500, 7, 11, 5000, 54, 100, 60, 250, 0, 2900, 83, 0.5].pack('f*')
      end

      def self.living_room
        new [500, 3, 4, 5000, 10, 100, 100, 250, 0, 160, 58, -19.0].pack('f*')
      end

      def self.stone_room
        new [2300, 12, 17, 5000, 64, 100, 100, 250, 0, 7800, 71, -8.5].pack('f*')
      end

      def self.auditorium
        new [4300, 20, 30, 5000, 59, 100, 100, 250, 0, 5850, 64, -11.7].pack('f*')
      end

      def self.concert_hall
        new [3900, 20, 29, 5000, 70, 100, 100, 250, 0, 5650, 80, -9.8].pack('f*')
      end

      def self.cave
        new [2900, 15, 22, 5000, 100, 100, 100, 250, 0, 20000, 59, -11.3].pack('f*')
      end

      def self.arena
        new [7200, 20, 30, 5000, 33, 100, 100, 250, 0, 4500, 80, -9.6].pack('f*')
      end

      def self.hangar
        new [10000, 20, 30, 5000, 23, 100, 100, 250, 0, 3400, 72, -7.4].pack('f*')
      end

      def self.carpeted_hallway
        new [300, 2, 30, 5000, 10, 100, 100, 250, 0, 500, 56, -24.0].pack('f*')
      end

      def self.hallway
        new [1500, 7, 11, 5000, 59, 100, 100, 250, 0, 7800, 87, -5.5].pack('f*')
      end

      def self.stone_corridor
        new [270, 13, 20, 5000, 79, 100, 100, 250, 0, 9000, 86, -6.0].pack('f*')
      end

      def self.alley
        new [1500, 7, 11, 5000, 86, 100, 100, 250, 0, 8300, 80, -9.8].pack('f*')
      end

      def self.forest
        new [1500, 162, 88, 5000, 54, 79, 100, 250, 0, 760, 94, -12.3].pack('f*')
      end

      def self.city
        new [1500, 7, 11, 5000, 67, 50, 100, 250, 0, 4050, 66, -26.0].pack('f*')
      end

      def self.mountains
        new [1500, 300, 100, 5000, 21, 27, 100, 250, 0, 1220, 82, -24.0].pack('f*')
      end

      def self.quarry
        new [1500, 61, 25, 5000, 83, 100, 100, 250, 0, 3400, 100, -5.0].pack('f*')
      end

      def self.plain
        new [1500, 179, 100, 5000, 50, 21, 100, 250, 0, 1670, 65, -28.0].pack('f*')
      end

      def self.parking_lot
        new [1700, 8, 12, 5000, 100, 100, 100, 250, 0, 20000, 56, -19.5].pack('f*')
      end

      def self.sewer_pipe
        new [2800, 14, 21, 5000, 14, 80, 60, 250, 0, 3400, 66, 1.2].pack('f*')
      end

      def self.underwater
        [1500, 7, 11, 5000, 10, 100, 100, 250, 0, 500, 92, 7.0].pack('f*')
      end
    end

    class Guid < Structure

      def initialize(address = nil)
        types = [TYPE_INT, TYPE_SHORT, TYPE_SHORT, [TYPE_CHAR, 8]]
        members = [:data1, :data2, :data3, :data4]
        super(address, types, members)
      end

      def data1
        [self[:data1]].pack('l').unpack1('L')
      end

      def data2
        [self[:data2]].pack('s').unpack1('S')
      end

      def data3
        [self[:data3]].pack('s').unpack1('S')
      end

      def data4
        self[:data4].pack('c*').unpack('C*')
      end

      def eql?(obj)
        if obj.is_a?(Guid)
          return false unless data1 == obj.data1
          return false unless data2 == obj.data2
          return false unless data3 == obj.data3
          return data4 == obj.data4
        end
        to_s.tr('-', '').casecmp(obj.to_s.tr('-', '')).zero?
      end

      def ==(obj)
        eql?(obj)
      end

      def to_s
        d4 = data4
        last = d4[2, 6].map { |byte| "%02X" % byte }.join
        "%08X-%04X-%04X-%02X%02X-#{last}" % [data1, data2, data3, d4[0], d4[1]]
      end
    end

    class SoundExInfo < Structure
      # TODO
    end

    class DspDescription < Structure
      # TODO
    end
  end
end









