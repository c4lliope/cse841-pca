require_relative 'algorithm'
require_relative 'vector'
require_relative 'ccipca'

class LearningAlgorithm < Algorithm
  def initialize(source)
    @source = source
    @pca = CCIPCA.new
  end

  def run
    images = source.images * source.epochs
    puts "="*images.count
    images.each do |image|
      print '.'
      pca.learn_image image
    end
    puts
    save_database
    output_report
    output_eigenvectors
  end

  private
  attr_reader :pca, :source

  def save_database
    puts "Writing database to #{source.database_path}"
    pca.write source.database_path
  end

  def output_eigenvectors
    eigenvectors = pca.eigenvectors
    puts "Calculated #{eigenvectors.count} eigenvectors"
    puts "Outputting to 'mef' directory"

    eigenvectors.each_with_index do |data, index|
      output data, "eigen_#{index}"
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
    "TODO The report string"
  end
end
