require_relative '../app/image'
require 'minitest/autorun'

describe Image do
  describe '::from_pgm' do
    it 'returns an image instance' do
      image = Image.from_pgm woman_filepath
      image.must_be_instance_of Image
    end

    it 'imports the correct witdh and height' do
      image.height.must_equal expected_woman.height
      image.width.must_equal expected_woman.width
    end

    private
    def image
      @_image ||= Image.from_pgm woman_filepath
    end
  end

  private

  ImageInfo = Struct.new(:filepath, :width, :height)

  def expected_woman
    @_expected_woman ||= ImageInfo.new 'test_image.pgm', 640, 480
  end

  def woman_filepath
    'test_image.pgm'
  end
end
