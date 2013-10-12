require 'minitest/autorun'
require_relative '../app/ccipca'
require_relative '../app/image'

describe CCIPCA do
  describe '.new' do
    it 'creates an empty set of eigenvectors' do
      pca = CCIPCA.new
      pca.eigenvectors.must_equal []
    end

    it 'sets the iteration count to 0' do
      pca = CCIPCA.new
      pca.iteration.must_equal 0
    end
  end

  describe 'learning one image' do
    it 'sets the mean to the image' do
      pca = CCIPCA.new
      pca.learn vector
      pca.mean.must_equal vector
    end

    private
    def vector
      Vector.new [1,2]
    end
  end

  describe 'learning two images' do
    it 'sets the mean correctly' do
      pca = CCIPCA.new
      pca.learn first_vector
      pca.learn second_vector
      pca.mean.must_equal mean_vector
    end

    it 'sets the first eigenvector' do
      pca = CCIPCA.new
      pca.learn first_vector
      pca.learn second_vector
      pca.eigenvectors.last.must_equal (second_vector - mean_vector)
    end

    private
    def first_vector
      Vector.new [1.0,2.0]
    end

    def second_vector
      Vector.new [2.0,1.0]
    end

    def mean_vector
      (first_vector + second_vector) / 2
    end
  end

  describe 'learning three images' do
    it 'sets the mean correctly' do
      learn_vectors
      pca.mean.must_equal mean_vector
    end

    it 'sets the eigenvectors' do
      learn_vectors
      pca.eigenvectors[1].must_equal Vector.new([1.6428047216990183, 3.9522761100647035, -1.3333333333333333])
      pca.eigenvectors.last.must_equal Vector.new([-0.156334938729092, -0.10557213329872006, -0.41419548831892833])
    end

    private
    def pca
      @_pca ||= CCIPCA.new
    end

    def learn_vectors
      vectors.each { |v| pca.learn v }
    end

    def vectors
      [
        Vector.new([1.0, -2.0, 3.0]),
        Vector.new([5.0, 8.0, -1.0]),
        Vector.new([2.0, 1.0, 1.0]),
      ]
    end

    def mean_vector
      vectors.reduce(&:+) / vectors.count
    end
  end
end
