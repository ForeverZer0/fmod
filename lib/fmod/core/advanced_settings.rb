module FMOD
  module Core
    class AdvancedSettings < Structure

      def initialize(address = nil)
        types = Array.new(9, TYPE_INT) + [TYPE_VOIDP, TYPE_VOIDP] + Array.new(4,
                TYPE_FLOAT) + [TYPE_INT, TYPE_SHORT, TYPE_INT, TYPE_FLOAT] +
                Array.new(8, TYPE_INT)
        members = [ :cb_ize, :max_MPEG_codecs, :max_ADPCM_codecs,
                    :max_XMA_codecs, :max_Vorbis_codecs, :max_AT9_codecs,
                    :max_FADPCM_codecs, :max_PCM_codecs, :ASIO_channels,
                    :ASI_channel_list, :ASIO_speaker_list, :HRTF_min_angle,
                    :HRTF_max_angle, :HRTF_freq, :vol0_virtual_vol,
                    :default_decode_buffer_size, :profile_port,
                    :geometry_max_fade_time, :distance_filter_center_freq,
                    :reverb3D_instance, :dsp_buffer_pool_size,
                    :stack_size_stream, :stack_size_non_blocking,
                    :stack_size_mixer, :resampler_method, :command_queue_size,
                    :random_seed]
        super(address, types, members)
      end

      [:cb_ize, :max_MPEG_codecs, :max_ADPCM_codecs, :max_XMA_codecs,
       :max_Vorbis_codecs, :max_AT9_codecs, :max_FADPCM_codecs, :max_PCM_codecs,
       :ASIO_channels, :ASI_channel_list, :ASIO_speaker_list, :HRTF_min_angle,
       :HRTF_max_angle, :HRTF_freq, :vol0_virtual_vol,
       :default_decode_buffer_size, :profile_port, :geometry_max_fade_time,
       :distance_filter_center_freq, :reverb3D_instance, :dsp_buffer_pool_size,
       :stack_size_stream, :stack_size_non_blocking, :stack_size_mixer,
       :resampler_method, :command_queue_size, :random_seed].each do |sym|

        define_method(sym) { self[sym] }
        define_method("#{sym}=") { |value| self[sym] = value }
      end
    end
  end
end