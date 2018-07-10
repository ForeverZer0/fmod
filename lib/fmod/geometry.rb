
module FMOD

  ##
  # FMOD supports the supply of polygon mesh data, that can be processed in
  # realtime to create the effect of occlusion in a real 3D world. In real world
  # terms, the user can stop sounds travelling through walls, or even confine
  # reverb inside a geometric volume so that it doesn't leak out into other
  # areas.
  class Geometry < Handle

    include Enumerable

    ##
    # @!attribute active
    # Value indicating if object will be processed in the geometry engine.
    #
    # @return [Boolean]
    bool_reader(:active, :Geometry_GetActive)
    bool_writer(:active=, :Geometry_SetActive)

    ##
    # @!attribute polygon_count
    # Retrieves the number of polygons stored within this {Geometry} object.
    #
    # @return [Integer]
    integer_reader(:polygon_count, :Geometry_GetNumPolygons)

    alias size polygon_count

    ##
    # @!attribute position
    # The position of the object in world space, which is the same space FMOD
    # sounds and listeners reside in.
    #
    # @return [Vector]

    def position
      FMOD.invoke(:Geometry_GetPosition, self, vector = Vector.zero)
      vector
    end

    def position=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:Geometry_SetPosition, self, vector)
    end

    ##
    # @!attribute scale
    # The relative scale vector of the geometry object. An object can be
    # scaled/warped in all 3 dimensions separately using the vector without
    # having to modify polygon data.
    # * *Default:* {Vector.one}
    #
    # @return [Vector]

    def scale
      FMOD.invoke(:Geometry_GetScale, self, vector = Vector.zero)
      vector
    end

    def scale=(vector)
      FMOD.type?(vector, Vector)
      FMOD.invoke(:Geometry_SetScale, self, vector)
    end

    ##
    # @!attribute rotation
    # The current orientation of the geometry object.
    #
    # @return [Rotation]
    # @see rotate

    def rotation
      forward, up = Vector.zero, Vector.zero
      FMOD.invoke(:Geometry_GetRotation, self, forward, up)
      Rotation.new(forward, up)
    end

    def rotation=(rotation)
      FMOD.type?(rotation, Rotation)
      rotate(*rotation.values)
    end

    ##
    # Sets the orientation of the geometry object.
    # @param forward [Vector] The forwards orientation of the geometry object.
    #   This vector must be of unit length and perpendicular to the upward
    #   vector. You can specify +nil+ to not update the forwards orientation of
    #   the geometry object.
    # @param upward [Vector] The upwards orientation of the geometry object.
    #   This vector must be of unit length and perpendicular to the forward
    #   vector. You can specify +nil+ to not update the upwards orientation of
    #   the geometry object.
    def rotate(forward, upward)
      FMOD.type?(forward, Vector) unless forward.nil?
      FMOD.type?(upward, Vector) unless upward.nil?
      FMOD.invoke(:Geometry_SetRotation, self, forward, upward)
    end

    ##
    # Retrieves the maximum number of polygons allocatable for this object.
    #
    # This is not the number of polygons currently present.
    #
    # @return [Integer]
    def max_polygons
      max = "\0" * SIZEOF_INT
      FMOD.invoke(:Geometry_GetMaxPolygons, self, max, nil)
      max.unpack1('l')
    end

    # Retrieves the maximum number of vertices allocatable for this object.
    #
    # This is not the number of vertices currently present.
    #
    # @return [Integer]
    def max_vertices
      max = "\0" * SIZEOF_INT
      FMOD.invoke(:Geometry_GetMaxPolygons, self, nil, max)
      max.unpack1('l')
    end

    ##
    # Retrieves the {Polygon} at the specified index.
    # @param index [Integer] The index of the Polygon to retrieve.
    # @return [Polygon]
    def [](index)
      return nil unless index.between?(0, polygon_count)
      Polygon.send(:new, self, index)
    end

    ##
    # Adds a polygon to an geometry object.
    #
    # @note A minimum of 3 vertices is required to create a {Polygon}.
    #
    # @param vertices [Array<Vector>] array of vertices located in object space.
    # @param direct [Float] Occlusion value which affects volume or audible
    #   frequencies.
    #   * *Minimum:* 0.0 The polygon does not occlude volume or audible
    #     frequencies (sound will be fully audible)
    #   * *Maximum:* 1.0 The polygon fully occludes (sound will be silent)
    # @param reverb [Float] Occlusion value from 0.0 to 1.0 which affects the
    #   reverb mix.
    #   * *Minimum:* 0.0 The polygon does not occlude reverb (reverb reflections
    #     still travel through this polygon)
    #   * *Maximum:* 1.0 The polygon fully occludes reverb (reverb reflections
    #     will be silent through this polygon).
    # @param double_sided [Boolean] Description of polygon if it is double sided
    #   or single sided.
    #   * *true:* Polygon is double sided
    #   * *false:* Polygon is single sided, and the winding of the polygon
    #     (which determines the polygon's normal) determines which side of the
    #     polygon will cause occlusion.
    def add_polygon(vertices, direct = 0.0, reverb = 0.0, double_sided = false)
      size = vertices.size
      unless size >= 3
        message = "3 or more vertices required for polygon: #{size} specified"
        raise ArgumentError, message
      end
      vectors = vertices.map(&:to_str).join
      direct = direct.clamp(0.0, 1.0)
      reverb = reverb.clamp(0.0, 1.0)
      FMOD.invoke(:Geometry_AddPolygon, self, direct, reverb,
                  double_sided.to_i, size, vectors, index = "\0" * SIZEOF_INT)
      Polygon.send(:new, self, index.unpack1('l'))
    end

    ##
    # Serializes the {Geometry} object into a binary block.
    #
    # @overload save(filename)
    #   @param filename [String] A filename where object will be saved to.
    #   @return [Boolean] +true+ if object was successfully flushed to disk,
    #     otherwise +false+.
    # @overload save
    #   Serializes the {Geometry} object and returns the data as a binary
    #   string.
    #   @return [String]
    # @see System.load_geometry
    def save(filename = nil)
      FMOD.invoke(:Geometry_Save, self, nil, size = "\0" * SIZEOF_INT)
      data = "\0" * size.unpack1('l')
      FMOD.invoke(:Geometry_Save, self, data, size)
      unless filename.nil?
        File.open(filename, 'wb') { |file| file.write(data) } rescue return false
        return true
      end
      data
    end

    ##
    # Enumerates the polygons contained within the {Geometry}.
    #
    # @overload each
    #   When called with block, yields each {Polygon} within the object before
    #   returning self.
    #   @yield [polygon] Yields a polygon to the block.
    #   @yieldparam polygon [Polygon] The current enumerated polygon.
    #   @return [self]
    # @overload each
    #   When no block specified, returns an Enumerator for the {Geometry}.
    #   @return [Enumerator]
    def each
      return to_enum(:each) unless block_given?
      (0...polygon_count).each { |i| yield self[i] }
      self
    end

    ##
    # Retrieves an array of {Polygon} objects within this {Geometry}.
    # @return [Array<Polygon>]
    def polygons
      (0...polygon_count).map { |i| self[i] }
    end

    ##
    # Describes the orientation of a geometry object.
    # @attr forward [Vector] The forwards orientation of the geometry object.
    #   This vector must be of unit length and perpendicular to the {#up}
    #   vector. You can specify +nil+ to not update the forwards orientation of
    #   the geometry object.
    # @attr up [Vector] The upwards orientation of the geometry object. This
    #   vector must be of unit length and perpendicular to the {#forward}
    #   vector. You can specify +nil+ to not update the upwards orientation of
    #   the geometry object.
    Rotation = Struct.new(:forward, :up)

    ##
    # @abstract
    # Wrapper class for a polygon within a {Geometry} object.
    class Polygon

      include Enumerable

      private_class_method :new

      ##
      # The parent geometry object.
      # @return [Geometry]
      attr_reader :geometry

      ##
      # The index of the {Polygon} within its parent {Geometry} object.
      # @return [Integer]
      attr_reader :index

      ##
      # Creates a new instance of a Polygon object.
      # @note Polygon objects should not be created by the user, only through
      #   {Geometry.add_polygon}, as they are an abstract wrapper only, not
      #   backed by an actual object.
      # @param geometry [Geometry] The parent geometry object.
      # @param index [Integer] The index of the polygon within the geometry.
      # @api private
      def initialize(geometry, index)
        @geometry, @index = geometry, index
      end

      ##
      # @!attribute direct_occlusion
      # The occlusion value from 0.0 to 1.0 which affects volume or audible
      # frequencies.
      # * *Minimum:* 0.0 The polygon does not occlude volume or audible
      #   frequencies (sound will be fully audible)
      # * *Maximum:* 1.0 The polygon fully occludes (sound will be silent)
      #
      # @return [Float]

      def direct_occlusion
        occlusion = "\0" * Fiddle::SIZEOF_FLOAT
        FMOD.invoke(:Geometry_GetPolygonAttributes, @geometry, @index,
                    occlusion, nil, nil)
        occlusion.unpack1('f')
      end

      def direct_occlusion=(occlusion)
        FMOD.invoke(:Geometry_SetPolygonAttributes, @geometry, @index,
                    occlusion.clamp(0.0, 1.0), reverb_occlusion, double_sided.to_i)
      end

      ##
      # @!attribute reverb_occlusion
      # The occlusion value from 0.0 to 1.0 which affects the reverb mix.
      # * *Minimum:* 0.0 The polygon does not occlude reverb (reverb
      #   reflections still travel through this polygon)
      # * *Maximum:* 1.0 The polygon fully occludes reverb (reverb
      #   reflections will be silent through this polygon)
      #
      # @return [Float]

      def reverb_occlusion
        occlusion = "\0" * Fiddle::SIZEOF_FLOAT
        FMOD.invoke(:Geometry_GetPolygonAttributes, @geometry, @index,
                    nil, occlusion, nil)
        occlusion.unpack1('f')
      end

      def reverb_occlusion=(occlusion)
        FMOD.invoke(:Geometry_SetPolygonAttributes, @geometry, @index,
                    direct_occlusion, occlusion.clamp(0.0, 1.0), double_sided.to_i)
      end

      ##
      # @!attribute double_sided
      # The description of polygon if it is double sided or single sided.
      # * *true:* The polygon is double sided
      # * *false:* The polygon is single sided, and the winding of the polygon
      #   (which determines the polygon's normal) determines which side of the
      #   polygon will cause occlusion.
      #
      # @return [Boolean]

      def double_sided
        double = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:Geometry_GetPolygonAttributes, @geometry, @index,
                    nil, nil, double)
        double.unpack1('l') != 0
      end

      def double_sided=(double_sided)
        FMOD.invoke(:Geometry_SetPolygonAttributes, @geometry, @index,
                    direct_occlusion, reverb_occlusion, double_sided.to_i)
      end

      ##
      # Retrieves the number of vertices within the polygon.
      # @return [Integer]
      def vertex_count
        count = "\0" * Fiddle::SIZEOF_INT
        FMOD.invoke(:Geometry_GetPolygonNumVertices, @geometry, @index, count)
        count.unpack1('l')
      end

      alias size vertex_count

      ##
      # Retrieves the vertex of the polygon at the specified index.
      # @param index [Integer] The index of the vertex to retrieve.
      # @return [Vector]
      def [](index)
        return nil unless index.between?(0, vertex_count - 1)
        vertex = Vector.zero
        FMOD.invoke(:Geometry_GetPolygonVertex, @geometry, @index, index, vertex)
        vertex
      end

      ##
      # Sets the vertex of the polygon at the specified index.
      # @param index [Integer] The index of the vertex to set.
      # @param vertex [Vector] The vertex to set.
      # @return [Vector] The vertex.
      def []=(index, vertex)
        unless index.between?(0, vertex_count - 1)
          message = "Index #{index} outside of bounds: 0...#{vertex.count}"
          raise IndexError, message
        end
        FMOD.type?(vertex, Vector)
        FMOD.invoke(:Geometry_SetPolygonVertex, @geometry, @index, index, vertex)
      end

      ##
      # @overload each
      #   When called with a block, yields each vertex in turn before returning
      #   self.
      #   @yield [vertex] Yields a vertex to the block.
      #   @yieldparam vertex [Vector] The enumerated vertex.
      #   @return [self]
      # @overload each
      #   Returns an Enumerator for the polygon.
      #   @return [Enumerator]
      def each
        return to_enum(:each) unless block_given?
        (0...vertex_count).each { |i| yield self[i] }
        self
      end

      ##
      # Retrieves an array of the vertices within the polygon.
      # @return [Array<Vector>]
      def vertices
        (0...vertex_count).map { |i| self[i] }
      end
    end
  end
end