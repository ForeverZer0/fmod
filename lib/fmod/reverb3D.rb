
module FMOD

  ##
  # The 3D reverb object is a sphere having 3D attributes (position, minimum
  # distance, maximum distance) and reverb properties.
  #
  # The properties and 3D attributes of all reverb objects collectively
  # determine, along with the listener's position, the settings of and input
  # gains into a single 3D reverb DSP.
  #
  # When the listener is within the sphere of effect of one or more 3D reverbs,
  # the listener's 3D reverb properties are a weighted combination of such 3D
  # reverbs. When the listener is outside all of the reverbs, the 3D reverb
  # setting is set to the default ambient reverb setting.
  class Reverb3D < Handle

    ##
    # @!attribute properties
    # Gets or sets the reverb parameters for the current reverb object.
    # @return [Reverb]

    ##
    # @!attribute position
    # A {Vector} containing the 3D position of the center of the reverb in 3D
    # space.
    # * *Default:* {Vector.zero}
    # @return [Vector]

    ##
    # @!attribute min_distance
    # The distance from the center-point that the reverb will have full effect
    # at.
    # * *Default:* 0.0
    # @return [Float]

    ##
    # @!attribute max_distance
    # The distance from the center-point that the reverb will not have any
    # effect.
    # * *Default:* 0.0
    # @return [Float]

    ##
    # @!attribute active
    # Gets or sets the a state to disable or enable a reverb object so that it
    # does or does not contribute to the 3D scene.
    #
    # @return [Boolean]
    bool_reader(:active, :Reverb3D_GetActive)
    bool_writer(:active=, :Reverb3D_SetActive)

    def min_distance
      buffer = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Reverb3D_Get3DAttributes, self, nil, buffer, nil)
      buffer.unpack1('f')
    end

    def min_distance=(distance)
      FMOD.invoke(:Reverb3D_Set3DAttributes, self, position,
        distance, max_distance )
    end

    def max_distance
      buffer = "\0" * SIZEOF_FLOAT
      FMOD.invoke(:Reverb3D_Get3DAttributes, self, nil, nil, buffer)
      buffer.unpack1('f')
    end

    def max_distance=(distance)
      FMOD.invoke(:Reverb3D_Set3DAttributes, self, position,
        min_distance, distance )
    end

    def position
      vector = Vector.zero
      FMOD.invoke(:Reverb3D_Get3DAttributes, self, vector, nil, nil)
      vector
    end

    def position=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:Reverb3D_Set3DAttributes, self, vector,
        min_distance, max_distance )
    end

    def properties
      FMOD.invoke(:Reverb3D_GetProperties, self, reverb = Reverb.new)
      reverb
    end

    def properties=(reverb)
      FMOD.type?(reverb, Reverb)
      FMOD.invoke(:Reverb3D_SetProperties, self, reverb)
      reverb
    end
  end
end