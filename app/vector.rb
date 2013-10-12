
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
end
