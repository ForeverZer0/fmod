

module FMOD

  module Core

    ##
    # Structure defining a reverb environment.
    class Reverb < Structure

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        types = Array.new(12, TYPE_FLOAT)
        members = [:decay_time, :early_delay, :late_delay, :hf_reference,
                   :hf_decay_ratio, :diffusion, :density, :low_shelf_freq,
                   :low_shelf_gain, :high_cut, :early_late_mix, :wet_level]
        super(address, types, members)
      end

      [:decay_time, :early_delay, :late_delay, :hf_reference, :hf_decay_ratio,
       :diffusion, :density, :low_shelf_freq, :low_shelf_gain, :high_cut,
       :early_late_mix, :wet_level].each do |symbol|
        define_method(symbol) {self[symbol]}
      end

      # @!attribute decay_time
      # Reverberation decay time (ms).
      # * *Minimum:* 0.0
      # * *Maximum:* 20000.0
      # * *Default:* 1500.0
      def decay_time=(value)
        self[:decay_time] = value.clamp(0.0, 20000.0)
      end

      # @!attribute early_delay
      # Initial reflection delay time (ms).
      # * *Minimum:* 0.0
      # * *Maximum:* 300.0
      # * *Default:* 7.0
      # @return [Float]
      def early_delay=(value)
        self[:early_delay] = value.clamp(0.0, 300.0)
      end

      # @!attribute late_delay
      # Late reverberation delay time relative to initial reflection (ms).
      # * *Minimum:* 0.0
      # * *Maximum:* 100.0
      # * *Default:* 11.0
      # @return [Float]
      def late_delay=(value)
        self[:late_delay] = value.clamp(0.0, 100.0)
      end

      # @!attribute hf_reference
      # Reference high frequency (Hz).
      # * *Minimum:* 20.0
      # * *Maximum:* 20000.0
      # * *Default:* 5000.0
      # @return [Float]
      def hf_reference=(value)
        self[:hf_reference] = value.clamp(20.0, 20000.0)
      end

      # @!attribute hf_decay_ratio
      # High-frequency to mid-frequency decay time ratio (%).
      # * *Minimum:* 10.0
      # * *Maximum:* 100.0
      # * *Default:* 50.0
      # @return [Float]
      def hf_decay_ratio=(value)
        self[:hf_decay_ratio] = value.clamp(10.0, 100.0)
      end

      # @!attribute diffusion
      # The echo density in the late reverberation decay (%).
      # * *Minimum:* 0.0
      # * *Maximum:* 100.0
      # * *Default:* 100.0
      # @return [Float]
      def diffusion=(value)
        self[:diffusion] = value.clamp(0.0, 100.0)
      end

      # @!attribute density
      # The modal density in the late reverberation decay (%).
      # * *Minimum:* 0.0
      # * *Maximum:* 100.0
      # * *Default:* 100.0
      # @return [Float]
      def density=(value)
        self[:density] = value.clamp(0.0, 100.0)
      end

      # @!attribute low_shelf_freq
      # Reference low frequency (Hz).
      # * *Minimum:* 20.0
      # * *Maximum:* 1000.0
      # * *Default:* 250.0
      # @return [Float]
      def low_shelf_freq=(value)
        self[:low_shelf_freq] = value.clamp(20.0, 1000.0)
      end

      # @!attribute low_shelf_gain
      # Relative room effect level at low frequencies (dB).
      # * *Minimum:* -36.0
      # * *Maximum:* 12.0
      # * *Default:* 0.0
      # @return [Float]
      def low_shelf_gain=(value)
        self[:low_shelf_gain] = value.clamp(-36.0, 12.0)
      end

      # @!attribute high_cut
      # Relative room effect level at high frequencies (Hz).
      # * *Minimum:* 20.0
      # * *Maximum:* 20000.0
      # * *Default:* 20000.0
      # @return [Float]
      def high_cut=(value)
        self[:high_cut] = value.clamp(20.0, 20000.0)
      end

      # @!attribute early_late_mix
      # Early reflections level relative to room effect (%).
      # * *Minimum:* 0.0
      # * *Maximum:* 100.0
      # * *Default:* 50.0
      # @return [Float]
      def early_late_mix=(value)
        self[:early_late_mix] = value.clamp(0.0, 100.0)
      end

      # @!attribute wet_level
      # Room effect level at mid frequencies (dB).
      # * *Minimum:* -80.0
      # * *Maximum:* 20.0
      # * *Default:* -6.0
      # @return [Float]
      def wet_level=(value)
        self[:wet_level] = value.clamp(-80.0, 20.0)
      end

      ##
      # Returns a pre-mad Reverb preset from the specified {ReverbIndex}.
      #
      # @param index [Integer] The index of the preset to retrieve.
      #
      # @return [Reverb] the reverb preset.
      def self.from_index(index)
        case index
        when ReverbIndex::GENERIC then generic
        when ReverbIndex::PADDED_CELL then padded_cell
        when ReverbIndex::ROOM then room
        when ReverbIndex::BATHROOM then bathroom
        when ReverbIndex::LIVING_ROOM then living_room
        when ReverbIndex::STONE_ROOM then stone_room
        when ReverbIndex::AUDITORIUM then auditorium
        when ReverbIndex::CONCERT_HALL then concert_hall
        when ReverbIndex::CAVE then cave
        when ReverbIndex::ARENA then arena
        when ReverbIndex::HANGAR then hangar
        when ReverbIndex::CARPETED_HALLWAY then carpeted_hallway
        when ReverbIndex::HALLWAY then hallway
        when ReverbIndex::STONE_CORRIDOR then stone_corridor
        when ReverbIndex::ALLEY then alley
        when ReverbIndex::FOREST then forest
        when ReverbIndex::CITY then city
        when ReverbIndex::MOUNTAINS then mountains
        when ReverbIndex::QUARRY then quarry
        when ReverbIndex::PLAIN then plain
        when ReverbIndex::PARKING_LOT then parking_lot
        when ReverbIndex::SEWER_PIPE then sewer_pipe
        when ReverbIndex::UNDERWATER then underwater
        else off
        end
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