
##
# Extensions to Numeric.
class Numeric

  ##
  # @return [Numeric] the value clamped between a minimum and maximum value.
  # @param min [Numeric] The minimum permitted value.
  # @param max [Numeric] The maximum permitted value.
  def clamp(min, max)
    [min, self, max].sort[1]
  end
end

##
# Extensions to String.
class String

  # Not defined until Ruby 2.4.0
  unless method_defined?(:unpack1)
    def unpack1(format)
      unpack(format).first
    end
  end
end

##
# Extensions to TrueClass.
class TrueClass

  ##
  # @return [Integer] the object as an Integer (1).
  def to_i
    1
  end
end

##
# Extensions to FalseClass.
class FalseClass

  ##
  # @return [Integer] the object as an Integer (0).
  def to_i
    0
  end
end