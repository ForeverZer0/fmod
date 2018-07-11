module FMOD
  module Core

    ##
    # Structure describing a data parameter for a DSP unit.
    class DataDescription < Structure

      ##
      # The default data type. All user data types should be 0 or above.
      TYPE_USER = 0

      ##
      # The data type for overall-gain parameters. There should a maximum of one
      # per DSP.
      TYPE_OVERALLGAIN = 1

      ##
      # The data type for 3D attribute parameters. There should a maximum of one
      # per DSP.
      TYPE_3DATTRIBUTES = 2

      ##
      # The data type for side-chain parameters. There should a maximum of one
      # per DSP.
      TYPE_SIDECHAIN = 3

      ##
      # The data type for FFT parameters. There should a maximum of one per DSP.
      TYPE_FFT = 4

      ##
      # The data type for multiple 3D attribute parameters. There should a
      # maximum of one per DSP.
      TYPE_3DATTRIBUTES_MULTI = 5

      ##
      # @param address [Pointer, Integer, String, nil] The address in memory
      #   where the structure will be created from. If no address is given, new
      #   memory will be allocated.
      def initialize(address = nil)
        super(address, [TYPE_INT], [:data_type])
      end

      ##
      # The type of data for this parameter. Use 0 or above for custom types or
      # set to one of the following are possible values:
      # * {TYPE_USER}
      # * {TYPE_OVERALLGAIN}
      # * {TYPE_3DATTRIBUTES}
      # * {TYPE_SIDECHAIN}
      # * {TYPE_FFT}
      # * {TYPE_3DATTRIBUTES_MULTI}
      def data_type
        self[:data_type]
      end
    end
  end
end