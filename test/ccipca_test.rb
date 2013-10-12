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
    it 'sets the mean' do
      pca = CCIPCA.new
      pca.learn first_image_data
      pca.learn second_image_data
      pca.mean.must_equal mean_vector
    end

    private
    def first_image_data
      Vector.new [1.0,2.0]
    end

    def second_image_data
      Vector.new [2.0,1.0]
    end

    def mean_vector
      (first_image_data + second_image_data) / 2
    end
  end
end
