require_relative 'algorithm'
require_relative 'ccipca'

class TestingAlgorithm
  def initialize(source)
    @source = source
    load_pca
    @matches = {}
  end

  def run
    puts "#{images.count} images to test"
    images.each_with_index do |image, index|
      @matches[image] = pca.closest_neighbor image.to_vector
      write index, image, @matches[image]
    end
    puts
    display_matches
    output_report
  end

  def display_matches
    @matches.each do |query, match|
      puts "#{query.path}: matched with #{match.path}"
    end
  end

  private
  attr_reader :pca, :source

  def write index, image, match
    File.open("output/#{index}_image.pgm", 'w') do |file|
      file << image.to_pgm
    end
    File.open("output/#{index}_match.pgm", 'w') do |file|
      file << match.to_pgm
    end
  end

  def images
    @_images ||= source.images.freeze
  end

  def vectors
    @_vectors ||= source.image_data_vectors.freeze
  end

  def load_pca
    puts "Loading PCA from #{source.database_path}"
    @pca = CCIPCA.load source.database_path
    puts "Database loaded"
  end

  def output_report
    # TODO write report
  end
end
