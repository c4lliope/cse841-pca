require_relative 'algorithm'
require_relative 'ccipca'

class TestingAlgorithm
  def initialize(source)
    @source = source
    load_pca
  end

  def run
    puts "#{vectors.count} images to test"
    vectors.each_with_index do |vector, index|
      closest = pca.closest_neighbor vector
      write index, vector, closest
    end
    puts
  end

  private
  attr_reader :pca, :source

  def write index, vector, match
    puts "Writing match #{index}"
    File.open("output/#{index}_image.pgm", 'w') do |file|
      file << Image.new(vector, 64, 88).to_pgm
    end
    File.open("output/#{index}_match.pgm", 'w') do |file|
      file << Image.new(match, 64, 88).to_pgm
    end
  end

  def vectors
    @_vectors ||= source.image_data_vectors.freeze
  end

  def load_pca
    puts "Loading PCA from #{source.database_path}"
    @pca = CCIPCA.load source.database_path
    puts "Database loaded"
  end
end
