# This is an input and output example for using command-line arguments
# and pgm images
#
# The program assigns pixels above a threshold to 255
# ./example -T threshold_value -f input_image.pgm -o output_image.pgm

require_relative 'app/image'

black = 0

require 'optparse'

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: example [options]"

    opts.on("-f", "--input INPUT_FILE", "Use the PGM-format INPUT_FILE") do |input_file|
      options[:input_file] = input_file
    end
    opts.on("-T", "--threshold THRESHOLD", "Set the threshold for the image") do |threshold|
      options[:threshold] = threshold
    end
    opts.on("-o", "--output OUTPUT_FILE", "Write to the PGM-format OUTPUT_FILE") do |output_file|
      options[:output_file] = output_file
    end
  end.parse!
  options
end

options = parse_options

threshold = options[:threshold].to_i
input_file = options[:input_file]
output_file = options[:output_file]

unless threshold && input_file && output_file
  puts "Incorrect arguments"
  exit
end

image = Image.from_pgm(input_file)

$stderr.puts "thresh=#{threshold}"
new_image_data = []
image.data.each do |pixel|
  if pixel > threshold
    new_image_data << 255
  else
    new_image_data << black
  end
end

new_image = Image.new new_image_data, image.width, image.height

output = File.open(output_file, 'w')
output << new_image.to_pgm(threshold)
output.close
