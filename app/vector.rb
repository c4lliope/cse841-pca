
class Vector < Array
  def initialize elements
    super elements
  end

  def self.zero(length)
    Vector.new(Array.new(length, 0))
  end

  def * scalar
    Vector.new self.map { |element| element * scalar }
  end

  def / scalar
    Vector.new self.map { |element| element / scalar }
  end

  def + other_vector
    verify_same_dimension(other_vector)
    Vector.new((0...count).map do |i|
      self[i] + other_vector[i]
    end)
  end

  def - other_vector
    verify_same_dimension(other_vector)
    Vector.new((0...count).map do |i|
      self[i] - other_vector[i]
    end)
  end

  def magnitude
    Math.sqrt(map { |x| x**2 }.reduce(&:+))
  end

  def normal
    self / self.magnitude
  end

  def to_s
    "<#{join ','}>"
  end

  def == other
    super(other) && other.class == self.class
  end

  def dot other
    verify_same_dimension other
    (0...count).map do |i|
      self[i] * other[i]
    end.reduce(&:+)
  end

  def div other
    verify_same_dimension(other)
    Vector.new((0...count).map do |i|
      self[i] / other[i]
    end)
  end

  private
  def verify_same_dimension other_vector
    unless other_vector.count == count
      raise "Error. Tried to operate on two vectors of different lengths"
    end
  end
end
