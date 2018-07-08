
module FMOD
  class DspConnection < Handle

    ##
    # Default connection type. Audio is mixed from the input to the output DSP's
    # audible buffer.
    STANDARD = 0
    ##
    # Sidechain connection type. Audio is mixed from the input to the output
    # DSP's sidechain buffer.
    SIDECHAIN = 1
    ##
    # Send connection type. Audio is mixed from the input to the output DSP's
    # audible buffer, but the input is *NOT* executed, only copied from. A
    # standard connection or sidechain needs to make an input execute to
    # generate.rb data.
    SEND = 2
    ##
    # Send sidechain connection type. Audio is mixed from the input to the
    # output DSP's sidechain buffer, but the input is *NOT* executed, only
    # copied from. A standard connection or sidechain needs to make an input
    # execute to generate.rb data.
    SEND_SIDECHAIN = 3

    ##
    # @!attribute [r] type
    # @return [Integer] the type of the connection between 2 DSP units.
    #
    #   Will be one of the following:
    #   * {STANDARD}
    #   * {SIDECHAIN}
    #   * {SEND}
    #   * {SEND_SIDECHAIN}
    integer_reader(:type, :DSPConnection_GetType)

    ##
    # @!attribute mix
    # The volume of the connection - the scale level of the input before being
    # passed to the output.
    # * *Minimum:* 0.0 (silent)
    # * *Maximum:* 1.0 (full volume)
    # * *Default:* 1.0
    # @return [Float] the volume or mix level.
    float_reader(:mix, :DSPConnection_GetMix)
    float_writer(:mix=, :DSPConnection_SetMix, 0.0, 1.0)

    ##
    # @!attribute [r] input
    # @return [Dsp] the DSP unit that is the input of this connection.
    def input
      dsp = int_ptr
      FMOD.invoke(:DSPConnection_GetInput, self, dsp)
      Dsp.from_handle(dsp)
    end

    ##
    # @!attribute [r] input
    # @return [Dsp] the DSP unit that is the output of this connection.
    def output
      dsp = int_ptr
      FMOD.invoke(:DSPConnection_GetOutput, self, dsp)
      Dsp.from_handle(dsp)
    end

    ##
    # @!attribute matrix
    # A 2D pan matrix that maps input channels (columns) to output speakers
    # (rows).
    #
    # Levels can be below 0 to invert a signal and above 1 to amplify the
    # signal. Note that increasing the signal level too far may cause audible
    # distortion.
    #
    # The matrix size will generally be the size of the number of channels in
    # the current speaker mode. Use {System.software_format }to determine this.
    #
    # If a matrix already exists then the matrix passed in will applied over the
    # top of it. The input matrix can be smaller than the existing matrix.
    #
    # A "unit" matrix allows a signal to pass through unchanged. For example for
    # a 5.1 matrix a unit matrix would look like this:
    #   [[ 1, 0, 0, 0, 0, 0 ]
    #    [ 0, 1, 0, 0, 0, 0 ]
    #    [ 0, 0, 1, 0, 0, 0 ]
    #    [ 0, 0, 0, 1, 0, 0 ]
    #    [ 0, 0, 0, 0, 1, 0 ]
    #    [ 0, 0, 0, 0, 0, 1 ]]
    #
    # @return [Array<Array<Float>>] a 2-dimensional array of volume levels in
    #   row-major order. Each row represents an output speaker, each column
    #   represents an input channel.
    def matrix
      o, i = "\0" * SIZEOF_INT, "\0" * SIZEOF_INT
      FMOD.invoke(:DSPConnection_GetMixMatrix, self, nil, o, i, 0)
      o, i = o.unpack1('l'), i.unpack1('l')
      return [] if o.zero? || i.zero?
      buffer = "\0" * (SIZEOF_FLOAT * o * i)
      FMOD.invoke(:DSPConnection_GetMixMatrix, self, buffer, nil, nil, 0)
      buffer.unpack('f*').each_slice(i).to_a
    end

    def matrix=(matrix)
      out_count, in_count = matrix.size, matrix.first.size
      unless matrix.all? { |ary| ary.size == in_count }
        raise Error, "Matrix contains unequal length input channels."
      end
      data = matrix.flatten.pack('f*')
      FMOD.invoke(:DSPConnection_SetMixMatrix, self, data,
        out_count, in_count, 0)
    end
  end
end