
class Numeric

  def clamp(min, max)
    [min, self, max].sort[1]
  end
end

class String

  unless method_defined?(:unpack1)
    def unpack1(format)
      unpack(format).first
    end
  end
end

class TrueClass
  def to_i
    1
  end
end

class FalseClass
  def to_i
    0
  end
end