module FMOD
  module Effects

    ##
    # This unit is a flexible five band parametric equalizer.
    #
    # See detailed description of each parameter to determine its effect with
    # each type of filter.
    class MultibandEq < Dsp

      ##
      # Valid bands used for the equalizer.
      BANDS = [:a, :b, :c, :d, :e].freeze

      ##
      # Retrieves the filter used for the specified band. The filter determines
      # the behavior of the other parameters.
      #
      # @param band [Symbol] The band.
      # @return [Integer] The current filter.
      # @see BANDS
      # @see FilterType
      def get_filter(band)
        index = BANDS.index(band) * 4
        get_integer(index)
      end

      ##
      # Retrieves the frequency for the specified band. This value has different
      # effects determined by the current filter.
      #
      # * *Low-pass/High-pass/Low-shelf/High-shelf:* Significant frequency in
      #   Hz, cutoff
      # * *Notch/Peaking/Band-pass:* Center
      # * *All-pass:* Phase transition point
      # @param band [Symbol] The band.
      # @return [Float]
      # @see BANDS
      # @see FilterType
      def get_frequency(band)
        index = (BANDS.index(band) * 4) + 1
        get_float(index)
      end

      ##
      # Retrieves the quality factor for the specified band. This value has
      # different effects determined by the current filter.
      #
      # * *Low-pass/High-pass:* Quality factor, resonance
      # * *Notch/Peaking/Band-pass:* Bandwidth
      # * *All-pass:* Phase transition sharpness
      # * *Low-shelf/High-shelf:* Unused
      # @param band [Symbol] The band.
      # @return [Float]
      # @see BANDS
      # @see FilterType
      def get_quality(band)
        index = (BANDS.index(band) * 4) + 2
        get_float(index)
      end

      ##
      # Retrieves the gain for the specified band.
      #
      # @note Peaking/Low-shelf/High-shelf only.
      # @param band [Symbol] The band.
      # @return [Float]
      # @see BANDS
      # @see FilterType
      def get_gain(band)
        index = (BANDS.index(band) * 4) + 3
        get_float(index)
      end

      ##
      # Sets the filter used for the specified band.
      #
      # The filter determines the behavior of the other parameters.
      # @param band [Symbol] The band.
      # @param filter [Integer] The filter to set, a {FilterType} value.
      # @return [self]
      # @see BANDS
      # @see FilterType
      def set_filter(band, filter)
        index = BANDS.index(band) * 4
        set_integer(index, filter.clamp(0, 12))
        self
      end

      ##
      # Sets the frequency for the specified band.  This value has different
      # effects determined by the current filter.
      #
      # * *Low-pass/High-pass/Low-shelf/High-shelf:* Significant frequency in
      #   Hz, cutoff
      # * *Notch/Peaking/Band-pass:* Center
      # * *All-pass:* Phase transition point
      # @param band [Symbol] The band.
      # @param frequency [Float] The frequency to set.
      #   * *Minimum:* 20.0
      #   * *Maximum:* 22000.0
      #   * *Default:* 8000.0
      # @return [self]
      # @see BANDS
      # @see FilterType
      def set_frequency(band, frequency)
        index = (BANDS.index(band) * 4) + 1
        set_float(index, frequency.clamp(20.0, 22000.0))
        self
      end

      ##
      # Set the quality factor for the specified band. This value has different
      # effects determined by the current filter.
      #
      # * *Low-pass/High-pass:* Quality factor, resonance
      # * *Notch/Peaking/Band-pass:* Bandwidth
      # * *All-pass:* Phase transition sharpness
      # * *Low-shelf/High-shelf:* Unused
      # @param band [Symbol] The band.
      # @param quality [Float] The quality factor.
      #   * *Minimum:* 0.1
      #   * *Maximum:* 10.0
      #   * *Default:* 0.707
      # @return [self]
      # @see BANDS
      # @see FilterType
      def set_quality(band, quality)
        index = (BANDS.index(band) * 4) + 2
        set_float(index, quality.clamp(0.1, 10.0))
        self
      end

      ##
      # Sets the gain for the specified band.
      #
      # @note Peaking/Low-shelf/High-shelf only.
      # @param band [Symbol] The band.
      # @param gain [Float] The boost or attenuation in dB.
      #   * *Minimum:* -30.0
      #   * *Maximum:* 30.0
      #   * *Default:* 0.0
      # @return [self]
      # @see BANDS
      # @see FilterType
      def set_gain(band, gain)
        index = (BANDS.index(band) * 4) + 3
        set_float(index, gain.clamp(-30.0, 30.0))
        self
      end
    end
  end
end