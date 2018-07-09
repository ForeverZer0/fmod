

module FMOD

  module Core
    ##
    # Structure defining a reverb environment.
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
        define_method(symbol) {self[symbol]}
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

      ##
      # @return [Reverb] no reverberation.
      def self.off
        new [1000, 7, 11, 5000, 100, 100, 100, 250, 0, 20, 96, -80.0].pack('f*')
      end

      ##
      # @return [Reverb] a generic reverb environment.
      def self.generic
        new [1500, 7, 11, 5000, 83, 100, 100, 250, 0, 14500, 96, -8.0].pack('f*')
      end

      ##
      # @return [Reverb] a padded cell environment.
      def self.padded_cell
        new [170, 1, 2, 5000, 10, 100, 100, 250, 0, 160, 84, -7.8].pack('f*')
      end

      ##
      # @return [Reverb] a room environment.
      def self.room
        new [400, 2, 3, 5000, 83, 100, 100, 250, 0, 6050, 88, -9.4].pack('f*')
      end

      ##
      # @return [Reverb] a bathroom environment.
      def self.bathroom
        new [1500, 7, 11, 5000, 54, 100, 60, 250, 0, 2900, 83, 0.5].pack('f*')
      end

      ##
      # @return [Reverb] a living room environment.
      def self.living_room
        new [500, 3, 4, 5000, 10, 100, 100, 250, 0, 160, 58, -19.0].pack('f*')
      end

      ##
      # @return [Reverb] a stone room environment.
      def self.stone_room
        new [2300, 12, 17, 5000, 64, 100, 100, 250, 0, 7800, 71, -8.5].pack('f*')
      end

      ##
      # @return [Reverb] an auditorium environment.
      def self.auditorium
        new [4300, 20, 30, 5000, 59, 100, 100, 250, 0, 5850, 64, -11.7].pack('f*')
      end

      ##
      # @return [Reverb] a concert hall environment.
      def self.concert_hall
        new [3900, 20, 29, 5000, 70, 100, 100, 250, 0, 5650, 80, -9.8].pack('f*')
      end

      ##
      # @return [Reverb] a cave environment.
      def self.cave
        new [2900, 15, 22, 5000, 100, 100, 100, 250, 0, 20000, 59, -11.3].pack('f*')
      end

      ##
      # @return [Reverb] an arena environment.
      def self.arena
        new [7200, 20, 30, 5000, 33, 100, 100, 250, 0, 4500, 80, -9.6].pack('f*')
      end

      ##
      # @return [Reverb] a hangar environment.
      def self.hangar
        new [10000, 20, 30, 5000, 23, 100, 100, 250, 0, 3400, 72, -7.4].pack('f*')
      end

      ##
      # @return [Reverb] a carpeted hallway environment.
      def self.carpeted_hallway
        new [300, 2, 30, 5000, 10, 100, 100, 250, 0, 500, 56, -24.0].pack('f*')
      end

      ##
      # @return [Reverb] a hallway environment.
      def self.hallway
        new [1500, 7, 11, 5000, 59, 100, 100, 250, 0, 7800, 87, -5.5].pack('f*')
      end

      ##
      # @return [Reverb] a stone corridor environment.
      def self.stone_corridor
        new [270, 13, 20, 5000, 79, 100, 100, 250, 0, 9000, 86, -6.0].pack('f*')
      end

      ##
      # @return [Reverb] an alley environment.
      def self.alley
        new [1500, 7, 11, 5000, 86, 100, 100, 250, 0, 8300, 80, -9.8].pack('f*')
      end

      ##
      # @return [Reverb] a forest environment.
      def self.forest
        new [1500, 162, 88, 5000, 54, 79, 100, 250, 0, 760, 94, -12.3].pack('f*')
      end

      ##
      # @return [Reverb] a city environment.
      def self.city
        new [1500, 7, 11, 5000, 67, 50, 100, 250, 0, 4050, 66, -26.0].pack('f*')
      end

      ##
      # @return [Reverb] a mountain environment.
      def self.mountains
        new [1500, 300, 100, 5000, 21, 27, 100, 250, 0, 1220, 82, -24.0].pack('f*')
      end

      ##
      # @return [Reverb] a quarry environment.
      def self.quarry
        new [1500, 61, 25, 5000, 83, 100, 100, 250, 0, 3400, 100, -5.0].pack('f*')
      end

      ##
      # @return [Reverb] a plain environment.
      def self.plain
        new [1500, 179, 100, 5000, 50, 21, 100, 250, 0, 1670, 65, -28.0].pack('f*')
      end

      ##
      # @return [Reverb] a parking lot environment.
      def self.parking_lot
        new [1700, 8, 12, 5000, 100, 100, 100, 250, 0, 20000, 56, -19.5].pack('f*')
      end

      ##
      # @return [Reverb] a sewer-pipe environment.
      def self.sewer_pipe
        new [2800, 14, 21, 5000, 14, 80, 60, 250, 0, 3400, 66, 1.2].pack('f*')
      end

      ##
      # @return [Reverb] an underwater environment.
      def self.underwater
        new [1500, 7, 11, 5000, 10, 100, 100, 250, 0, 500, 92, 7.0].pack('f*')
      end
    end
  end
end