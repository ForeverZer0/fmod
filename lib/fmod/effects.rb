
module FMOD
  module Effects

    require_relative 'effects/channel_mix.rb'
    require_relative 'effects/chorus.rb'
    require_relative 'effects/compressor.rb'
    require_relative 'effects/convolution_reverb.rb'
    require_relative 'effects/delay.rb'
    require_relative 'effects/distortion.rb'
    require_relative 'effects/dsps.rb'
    require_relative 'effects/echo.rb'
    require_relative 'effects/envelope_follower.rb'
    require_relative 'effects/fader.rb'
    require_relative 'effects/fft.rb'
    require_relative 'effects/flange.rb'
    require_relative 'effects/high_pass.rb'
    require_relative 'effects/high_pass_simple.rb'
    require_relative 'effects/it_echo.rb'
    require_relative 'effects/it_lowpass.rb'
    require_relative 'effects/ladspa_plugin.rb'
    require_relative 'effects/limiter.rb'
    require_relative 'effects/loudness_meter.rb'
    require_relative 'effects/low_pass.rb'
    require_relative 'effects/low_pass_simple.rb'
    require_relative 'effects/mixer.rb'
    require_relative 'effects/multiband_eq.rb'
    require_relative 'effects/normalize.rb'
    require_relative 'effects/object_pan.rb'
    require_relative 'effects/oscillator.rb'
    require_relative 'effects/pan.rb'
    require_relative 'effects/param_eq.rb'
    require_relative 'effects/pitch_shift.rb'
    require_relative 'effects/return.rb'
    require_relative 'effects/send.rb'
    require_relative 'effects/sfx_reverb.rb'
    require_relative 'effects/three_eq.rb'
    require_relative 'effects/transceiver.rb'
    require_relative 'effects/tremolo.rb'
    require_relative 'effects/vst_plugin.rb'
    require_relative 'effects/winamp_plugin.rb'

    deprecate_constant :HighPass
    deprecate_constant :HighPassSimple
    deprecate_constant :LowPass
    deprecate_constant :LowPassSimple
    deprecate_constant :LadspaPlugin
  end
end
