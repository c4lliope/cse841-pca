
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
    unless other_vector.count == count
      raise "Error. Tried to add two vectors of different lengths"
    end
    (0...count).map do |i|
      self[i] + other_vector[i]
    end
  end

  def magnitude
    Math.sqrt(map { |x| x**2 }.reduce(&:+))
  end

  def to_s
    "<#{join ','}>"
  end
end
