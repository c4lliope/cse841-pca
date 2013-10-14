# CSE 841 Homework 2: CCI PCA
# Submission by Grayson Wright
# ============================

require 'optparse'
require 'ostruct'
class Configuration < OpenStruct
  def self.from_options
    options = OpenStruct.new
    OptionParser.new do |opts|
      options.mode = :testing
      opts.banner = "Usage: example [options]"

      opts.on("-l epochs", "--learning EPOCHS", Integer, "Set the number of epochs to use for the training run") do |epochs|
        options.mode = :learning
        options.epochs = epochs
      end
      opts.on("-f image_index", "--input IMAGE_INDEX", "run the program on FILES") do |image_index|
        options.image_index = image_index
      end
      opts.on("-d", "--networkfile NETFILE", "Store the network data in NETFILE") do |netfile|
        options.network_file = netfile
      end
      opts.on("-o", "--output OUTPUT_FILE", "Write to the PGM-format OUTPUT_FILE") do |output_file|
        options.output_file = output_file
      end
    end.parse!
    options
  end
end

