require_relative 'vector'

class CCIPCA
  def initialize
    @eigenvectors = []
    @iterations = 0
  end

  def learn vector
    update_mean vector
  end

  attr_reader :eigenvectors, :iterations, :mean

  private
  def update_mean vector
    @mean = vector
  end

  def iterations= value
    @iterations = value
  end
end
