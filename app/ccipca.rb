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
    if iteration > 1
      update_eigenvector 1, scatter(vector)
    end
  end

  private

  def update_eigenvector index, vector
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
  end

  def t
    iteration.to_f
  end

  def iterations= value
    @iterations = value
  end
end
