
module FMOD
  module Effects

    ##
    # @deprecated  Unsupported / Deprecated.
    class LadspaPlugin < Dsp

      def initialize
        raise NotImplementedError, "LADSPA Plugins are no longer supported."
      end
    end
  end
end