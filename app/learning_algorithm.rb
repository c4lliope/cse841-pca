require_relative 'algorithm'
require_relative 'vector'

class LearningAlgorithm < Algorithm
  def initialize(source)
    @source = source
    @eigenvectors = []
    @iteration = 0
  end

  attr_accessor :eigenvectors

  def run
    eigenvectors[0] = mean_vector
    puts "="*vectors.count
    (0...vectors.count).each do |t|
      print "."
      t = t.to_f
      vector = vectors[t]
      scatter = vector - mean_vector

      residual = scatter
      1.upto(min(max_eigenvector_count,t)) do |i|
        if i == t
          eigenvectors[i] = residual
        else
          normalized_eigenvector = eigenvectors[i] / eigenvectors[i].magnitude
          similarity_to_eigenvector = residual.dot(normalized_eigenvector)
          memory_weight = (t - 1 - amnesia) / t
          new_vector_weight = (1 + amnesia)/t
          eigenvectors[i] = (eigenvectors[i] * memory_weight) +
            (residual * similarity_to_eigenvector * new_vector_weight)
          residual = residual - (normalized_eigenvector * similarity_to_eigenvector)
        end
      end
    end

    output_eigenvectors
  end

  private
  def vectors
    @_vectors ||= source.image_data_vectors
  end

  def mean_vector
    @_mean_vector ||= mean vectors
  end

  def output_eigenvectors
    puts "Calculated #{eigenvectors.count} eigenvectors"
    puts "Outputting to 'output' directory"

    eigenvectors.each_with_index do |data, index|
      output data, "eigen_#{index}"
    end
  end

  def amnesia
    0.0
  end

  def min(a,b)
    a < b ? a : b
  end

  def mean vectors
    vectors.reduce(&:+) / vectors.count
  end

  def output data, filename
    File.open(File.absolute_path("output/#{filename}.pgm"), 'w') do |file|
      file << Image.new(data, 64, 88).to_pgm
    end
  end

  def max_eigenvector_count
    100
  end
end
