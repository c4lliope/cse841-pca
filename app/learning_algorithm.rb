require_relative 'algorithm'
require_relative 'vector'
require_relative 'ccipca'

class LearningAlgorithm < Algorithm
  def initialize(source)
    @source = source
    @pca = CCIPCA.new
  end

  def run
    vectors = source.image_data_vectors * source.epochs
    puts "="*vectors.count
    vectors.each do |vector|
      print '.'
      pca.learn vector
    end
    puts
    save_database
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
    puts "Outputting to 'output' directory"

    eigenvectors.each_with_index do |data, index|
      output data, "eigen_#{index}"
    end
  end

  def output data, filename
    File.open(File.absolute_path("output/#{filename}.pgm"), 'w') do |file|
      file << Image.new(data, 64, 88).normalize.to_pgm
    end
  end
end
