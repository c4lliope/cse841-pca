require_relative 'vector'

class CCIPCA
  def initialize
    @eigenvectors = []
    @iteration = 0
  end

  def learn vector
    @iteration += 1
    update_mean vector
  end

  attr_reader :eigenvectors, :iteration, :mean

  private
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
