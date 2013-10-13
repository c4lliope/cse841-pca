require_relative 'algorithm'
require_relative 'ccipca'

class TestingAlgorithm
  def initialize(source)
    @source = source
    load_pca
  end

  def run
    puts "=" * vectors.count
    variances = []
    vectors.each do |vector|
      print '.'
      score = pca.score vector
      variance = score.magnitude / vector.magnitude
      variances << variance
    end
    puts
  end

  private
  attr_reader :pca, :source

  def vectors
    @_vectors ||= source.image_data_vectors.freeze
  end

  def load_pca
    puts "Loading PCA from #{source.database_path}"
    @pca = CCIPCA.load source.database_path
    puts "Database loaded"
  end
end
