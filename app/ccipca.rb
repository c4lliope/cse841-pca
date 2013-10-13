require_relative 'vector'
require 'yaml'

class CCIPCA
  attr_reader :eigenvectors, :iteration, :mean, :max_eigen_count

  def initialize(eigen_count = 64)
    @eigenvectors = []
    @iteration = 0
    @max_eigen_count = eigen_count
    @vector_archive = []
  end

  def learn vector
    @iteration += 1
    @vector_archive << vector
    update_mean vector
    if iteration > 1
      update_eigenvector 1, scatter(vector)
    end
  end

  def score vector
    basis_from_eigenvectors 1, scatter(vector)
  end

  def closest_neighbor vector
    query = Vector.new(basis_from_eigenvectors(0, scatter(vector)))
    closest_index = 0
    previous_closest = 10000000
    (0...archived_bases.keys.count).each do |index|
      candidate = archived_bases.keys[index]
      displacement = query - candidate
      puts "index #{index}, score: #{displacement.magnitude}"
      if displacement.magnitude < previous_closest
        closest_index = index
        previous_closest = displacement.magnitude
      end
    end
    puts "Selected matching index: #{closest_index}"
    base = archived_bases.keys[closest_index]
    archived_bases[base]
  end

  def archived_bases
    @_archived_bases ||= begin
                           puts "Calculating bases for archived vectors"
                           bases = {}
                           puts '=' * @vector_archive.count
                           @vector_archive.each do |archived|
                             print '.'
                             new_basis = Vector.new(basis_from_eigenvectors(0, scatter(archived)))
                             bases[new_basis] = archived
                           end
                           puts
                           bases
                         end
  end

  def write path
    @vector_archive.uniq!
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

  def basis_from_eigenvectors index, vector
    if index >= eigenvectors.count
      []
    else
      response = vector.dot eigenvectors[index].normal
      residual = vector - eigenvectors[index].normal * response
      [response] + basis_from_eigenvectors(index + 1, residual)
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
