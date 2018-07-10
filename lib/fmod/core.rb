
module FMOD

  ##
  # Namespace for classes and structures used primarily within the API, to
  # create a logical separation of the native FMOD classes from enumerations,
  # structures, and internally used data types.
  module Core
    require_relative './core/structure'
    require_relative './core/structures'
    require_relative './core/bool_description'
    require_relative './core/channel_mask'
    require_relative './core/data_description'
    require_relative './core/driver'
    require_relative './core/dsp_description'
    require_relative './core/dsp_index'
    require_relative './core/dsp_type'
    require_relative './core/extensions'
    require_relative './core/file_system'
    require_relative './core/filter_type'
    require_relative './core/float_description'
    require_relative './core/guid'
    require_relative './core/init_flags'
    require_relative './core/integer_description'
    require_relative './core/mode'
    require_relative './core/output_type'
    require_relative './core/parameter_info'
    require_relative './core/parameter_type'
    require_relative './core/result'
    require_relative './core/reverb_index'
    require_relative './core/reverb'
    require_relative './core/sound_ex_info'
    require_relative './core/sound_format'
    require_relative './core/sound_group_behavior'
    require_relative './core/sound_type'
    require_relative './core/speaker_index'
    require_relative './core/speaker_mode'
    require_relative './core/spectrum_data'
    require_relative './core/tag'
    require_relative './core/tag_data_type'
    require_relative './core/time_unit'
    require_relative './core/vector'
    require_relative './core/window_type'
  end
end