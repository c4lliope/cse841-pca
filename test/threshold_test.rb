require 'minitest/autorun'

describe 'Thresholding' do
  `gcc given/example.c`
  0.upto(255) do |threshold|
    describe "with a threshold of #{threshold}" do
      it 'generates the same output as the example program' do
        test_threshold_value(threshold)
      end
    end
  end

  private
  def test_threshold_value threshold
    `ruby example.rb -f #{original} -T #{threshold} -o #{ruby_output(threshold)} 2>&1`
    `./a.out -f #{original} -T #{threshold} -o #{c_output(threshold)} 2>&1`
    `diff #{c_output(threshold)} #{ruby_output(threshold)}`.must_equal ''
  end

  def output_dir
    'tmp/'
  end

  def original
    'test/test_image.pgm'
  end

  def c_output(threshold='')
    output_dir + "output_#{threshold}_c.pgm"
  end

  def ruby_output(threshold='')
    output_dir + "output_#{threshold}_rb.pgm"
  end
end
