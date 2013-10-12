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
      pca.iterations.must_equal 0
    end
  end

  describe 'learning one image' do
    it 'sets the 0th eigenvector to the image' do
      pca = CCIPCA.new
      pca.learn image_data_vector
      pca.mean.must_equal image_data_vector
    end

    private
    def image_data_vector
      @_image_data_vector ||= Vector.new image.data
    end

    def image
      Image.from_raw File.absolute_path('test/images/grayson.raw'), 64, 88
    end
  end
end
