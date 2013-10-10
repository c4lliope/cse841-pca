require 'minitest/autorun'

describe 'Thresholding' do
  `gcc given/example.c -o tmp/c_threshold.o`

  def self.test_values
    (0...255).step(64).to_a + edge_cases
  end

  def self.edge_cases
    [0,1,2,9,10,11,254,255]
  end

  test_values.each do |threshold|
    describe "with a threshold of #{threshold}" do
      it 'generates the same output as the example program' do
        test_threshold_value(threshold)
      end
    end
  end

  private
  def test_threshold_value threshold
    `ruby threshold.rb -f #{original} -T #{threshold} -o #{ruby_output} 2>&1`.must_equal `./#{c_executable} -f #{original} -T #{threshold} -o #{c_output} 2>&1`
    `diff #{c_output} #{ruby_output}`.must_equal ''
  end

  def output_dir
    'tmp/'
  end

  def original
    'test/test_image.pgm'
  end

  def c_output
    output_dir + "output_c.pgm"
  end

  def ruby_output
    output_dir + "output_rb.pgm"
  end

  def c_executable
    output_dir + 'c_threshold.o'
  end
end
