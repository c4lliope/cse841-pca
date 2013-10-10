require_relative '../app/image'
require 'minitest/autorun'

describe Image do
  describe '::from_pgm' do
    it 'returns an image instance' do
      image = Image.from_pgm test_file_name
      image.must_be_instance_of Image
    end
  end

  private
  def test_file_name
    'test_image.pgm'
  end
end
