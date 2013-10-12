require_relative 'algorithm'
require_relative 'vector'

class LearningAlgorithm < Algorithm
  def initialize(source)
    @source = source
    @eigenvectors = []
    @iteration = 0
  end

  attr_accessor :eigenvectors

  def k
    max_eigenvector_count = 5
  end

  def run
    vectors = source.image_data_vectors
    (0..vectors.count).each do |t|
      t = t.to_f
      vector = vectors[t]
      mean_vector ||= Vector.zero(vector.count)
      mean_vector = (mean_vector * t/(t+1)) + (vector * 1/(t+1))
      scatter = vector - mean_vector

      residual = scatter
      # Calculate the i-th component of the dense response y
      components = []
      1.upto(min(k,t)) do |i|
        if i == t
          eigenvectors[i] = residual
        else
          scaling_factor = eigenvectors[i] / eigenvectors[i].magnitude
          y = residual.dot(scaling_factor)
          w1 = (t - 1 - mu) / t
          w2 = (1 + mu)/t
          eigenvectors[i] = (eigenvectors[i] * w1) + (residual * w2 * y)
          residual = residual - (scaling_factor * y)
        end
      end
    end
  end

  def mu
    amnesia = 3.0
  end

  def min(a,b)
    a < b ? a : b
  end
end
