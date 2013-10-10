# This is an input and output example for using command-line arguments
# and pgm images
#
# The program assigns pixels above a threshold to 255
# ./example -T threshold_value -f input_image.pgm -o output_image.pgm

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
  puts "Incorrect arguments."
  exit
end

file = File.open input_file

header = file.readline
unless header.strip == 'P5'
  raise 'Invalid file header'
end

column_count, row_count = file.readline.split.map(&:to_i)
white = file.readline.to_i

data = file.read
data = data.unpack("C*")
rows = (0...row_count).map do
  data.shift column_count
end

file.close

$stderr.puts "thresh=#{threshold}"
new_image = rows
rows.each_with_index do |row, row_index|
  row.each_with_index do |pixel, column_index|
    if pixel > threshold
      new_image[row_index][column_index] = white
    else
      new_image[row_index][column_index] = black
    end
  end
end

def output_string_for_image image, threshold, column_count, row_count, black, white
  output = "P5\n"
  output << "# generated by example program for project 2\n"
  output << "#{column_count} #{row_count} \n"
  output << "#{white}\n"
  if threshold < 10
    output << [255].pack("C")
  else
    output << [0].pack("C")
  end
  data_string = ''
  image.each do |row|
    data_string << row.pack("C*")
  end
  output << data_string[0...-1]
  output
end

output = File.open(output_file, 'w')
output << output_string_for_image(new_image, threshold, column_count, row_count, black, white)
output.close
