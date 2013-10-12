require_relative 'vector'

class CCIPCA
  attr_reader :eigenvectors, :iteration, :mean

  def initialize
    @eigenvectors = []
    @iteration = 0
  end

  def learn vector
    @iteration += 1
    update_mean vector
    update_eigenvector 1, scatter(vector)
  end

  private

  def update_eigenvector index, vector
    response = vector.dot eigenvector[index].normal
    @eigenvector[index] = eigenvector[index] * retention_rate +
      vector * response * learning_rate
    residual = vector - eigenvector[index].normal * response
    update_eigenvector index + 1, residual
  end

  def scatter vector
    vector - mean
  end

  def update_mean vector
    @mean ||= vector
    @mean = vector * (1.0/t) + mean * (t - 1.0)/t
  end

  def t
    iteration.to_f
  end

  def iterations= value
    @iterations = value
  end
end
