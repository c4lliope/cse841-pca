# CSE 841 Homework 2: CCI PCA
# Submission by Grayson Wright
# LearningAlgorithm
# Runs the learning portion of the assignment
# ============================

require_relative 'algorithm'
require_relative 'vector'
require_relative 'ccipca'

class LearningAlgorithm < Algorithm
  def initialize(source)
    @source = source
    @pca = CCIPCA.new source.mef_count
  end

  def run
    images = source.images * source.epochs
    puts "Learning images... this may take a while"
    images.each do |image|
      pca.learn_image image
    end
    save_database
    output_report
    output_eigenvectors
  end

  private
  attr_reader :pca, :source

  def save_database
    puts "Writing database to #{source.database_path}, this may take a while"
    pca.write source.database_path
  end

  def output_eigenvectors
    eigenvectors = pca.eigenvectors
    puts "Calculated #{eigenvectors.count - 1} principal components"
    puts "Outputting to 'mef' directory"

    eigenvectors.each_with_index do |data, index|
      output data, "#{index}"
    end
  end

  def output data, filename
    File.open(File.absolute_path("mef/#{filename}.pgm"), 'w') do |file|
      file << Image.new(data, 64, 88).normalize.to_pgm
    end
  end

  def output_report
    File.open report_file, 'w' do |file|
      file << report
    end
  end

  def report_file
    source.output_file
  end

  def report
    [header, mean_filename, mef_filenames].join seperator
  end

  def header
    "Output for pcanet.rb by Grayson Wright
Learning mode
#{source.epochs} epochs
Database file: #{source.database_path}
Testing List: #{source.input_file}
#{source.images.count} images read
#{source.mef_count} MEFs calculated"
  end

  def seperator
    "\n"*2
  end

  def mean_filename
    "Mean filename: mef/0.pmf"
  end

  def mef_filenames
    1.upto(source.mef_count).map do |index|
      "MEF image ##{index}: mef/#{index}.pgm"
    end.join "\n"
  end

  def output_file
    source.output_file
  end
end
