require_relative '../app/image'
require 'minitest/autorun'

describe Image do

  describe '#new' do
    it 'takes and stores a height and width, and data' do
      image = Image.new(sample_data, 4, 5)
      image.data.must_equal sample_data
      image.width.must_equal 4
      image.height.must_equal 5
    end

    private
    def sample_data
      'abcde'
    end
  end

  describe '::from_pgm' do
    it 'returns an image instance' do
      woman_image = Image.from_pgm woman.filepath
      woman_image.must_be_instance_of Image
    end

    it 'imports the correct witdh' do
      woman_image.width.must_equal woman.width
      baboon_image.width.must_equal baboon.width
    end

    it 'imports the correct height' do
      woman_image.height.must_equal woman.height
      baboon_image.height.must_equal baboon.height
    end

    private
    def woman_image
      @_woman_image ||= Image.from_pgm woman.filepath
    end

    def baboon_image
      @_baboon_image ||= Image.from_pgm baboon.filepath
    end
  end

  private

  ImageInfo = Struct.new(:filepath, :width, :height)

  def woman
    @_woman ||= ImageInfo.new File.absolute_path('test/test_image.pgm'), 640, 480
  end

  def baboon
    @_baboon ||= ImageInfo.new File.absolute_path('test/baboon.pgm'), 512, 512
  end
end
