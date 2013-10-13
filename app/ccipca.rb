require_relative 'vector'
require 'yaml'

class CCIPCA
  attr_reader :eigenvectors, :iteration, :mean, :max_eigen_count

  def initialize(eigen_count = 50)
    @eigenvectors = []
    @iteration = 0
    @max_eigen_count = eigen_count
  end

  def learn vector
    @iteration += 1
    update_mean vector
    if iteration > 1
      update_eigenvector 1, scatter(vector)
    end
  end

  def score vector
    residual_from_eigenvectors 1, scatter(vector)
  end

  def write path
    File.open path, 'w' do |file|
      file << YAML::dump(self)
    end
  end

  def self.load path
    File.open path do |file|
      YAML::load file.read
    end
  end

  def == other
    eigenvectors == other.eigenvectors
    iteration == other.iteration
    max_eigen_count == other.max_eigen_count
  end

  private

  def residual_from_eigenvectors index, vector
    if index >= eigenvectors.count
      vector
    else
      response = vector.dot eigenvectors[index].normal
      residual = vector - eigenvectors[index].normal * response
      residual_from_eigenvectors index + 1, residual
    end
  end

  def update_eigenvector index, vector
    return if index > max_eigen_count
    if index >= eigenvectors.count
      @eigenvectors[index] = vector
    else
      response = vector.dot eigenvectors[index].normal
      retained = eigenvectors[index] * retention_rate
      learned = vector * response * learning_rate
      @eigenvectors[index] = retained + learned
      residual = vector - eigenvectors[index].normal * response
      update_eigenvector index + 1, residual
    end
  end

  def retention_rate
    amnesia = 0
    (t - 1.0 - amnesia) / t
  end

  def learning_rate
    1.0 - retention_rate
  end

  def scatter vector
    vector - mean
  end

  def update_mean vector
    @mean ||= vector
    @mean = vector * (1.0/t) + mean * (t - 1.0)/t
    @eigenvectors[0] = @mean
  end

  def t
    iteration.to_f
  end

  def iterations= value
    @iterations = value
  end
end
