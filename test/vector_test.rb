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
end
