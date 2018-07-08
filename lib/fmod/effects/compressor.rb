module FMOD
  module Effects

    ##
    # This unit implements dynamic compression (linked/unlinked multichannel, wide-band).
    #
    # @attr threshold [Float] Threshold level (dB).
    #   * *Minimum:* -80.0
    #   * *Maximum:* 0.0
    #   * *Default:* 0.0
    # @attr ratio [Float] Compression Ratio (dB/dB).
    #   * *Minimum:* 1.0
    #   * *Maximum:* 50.0
    #   * *Default:* 2.5
    # @attr attack [Float] Attack time (milliseconds).
    #   * *Minimum:* 0.1
    #   * *Maximum:* 1000.0
    #   * *Default:* 20.0
    # @attr release_time [Float] Release time (milliseconds).
    #   * *Minimum:* 10.0
    #   * *Maximum:* 5000.0
    #   * *Default:* 100.0
    # @attr make_up_gain [Float] Make-up gain (dB) applied after limiting.
    #   * *Minimum:* 0.0
    #   * *Maximum:* 30.0
    #   * *Default:* 0.0
    # @attr use_sidechain [Boolean] Whether to analyse the sidechain signal
    #   instead of the input signal.
    #   * *Default:* +false+
    # @attr linked [Boolean]
    #   * *true:* Linked
    #   * *false:* Independent (compressor per channel)
    #   * *Default:* +false+
    class Compressor < Dsp
      float_param(0, :threshold, min: -60.0, mix: 0.0)
      float_param(1, :ratio, min: 1.0, max: 50.0)
      float_param(2, :attack, min: 0.1, max: 500.0)
      float_param(3, :release_time, min: 10.0, max: 5000.0)
      float_param(4, :make_up_gain, min: -30.0, max: 30.0)
      bool_param(6, :linked)

      def sidechain
        get_data(5).to_s(SIZEOF_INT).unpack1('l') != 0
      end

      def sidechain=(bool)
        value = [bool.to_i].pack('l')
        set_data(5, value)
      end
    end
  end
end