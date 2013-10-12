require_relative '../app/vector'
require 'minitest/autorun'

describe Vector do
  describe 'initialization' do
    it 'takes an array' do
      v = Vector.new [1,2,3]
      v.count.must_equal 3
    end
  end

  describe '.zero' do
    it 'returns a zero vector of the appropriate length' do
      Vector.zero(3).must_equal Vector.new([0,0,0])
    end
  end

  describe 'multiplication by a scalar' do
    it 'returns a new vector with the result' do
      (Vector.new([1,2,3]) * 3).must_equal Vector.new([3,6,9])
    end
  end

  describe 'division by a scalar' do
    it 'returns a new vector with the result' do
      (Vector.new([3,6,9]) / 3).must_equal Vector.new([1,2,3])
    end
  end

  describe 'addition with another vector' do
    it 'adds the elements' do
      a = Vector.new([1,2,3])
      b = Vector.new([5,2,-1])
      (a+b).must_equal Vector.new([6,4,2])
    end
  end

  describe '#magnitude' do
    it 'returns the magnitude' do
      Vector.new([0]).magnitude.must_equal 0
      Vector.new([1]).magnitude.must_equal 1
      Vector.new([3,4]).magnitude.must_equal 5
    end
  end
end
