require_relative 'configuration'
require_relative 'learning_algorithm'
require_relative 'testing_algorithm'
require_relative 'image'

class DataSource
  def initialize(config)
    @config = config
    parse_index_file
  end

  attr_reader :people
  attr_reader :image_count_for_class
  attr_reader :test_images

  def algorithm
    if config.mode == :learning
      LearningAlgorithm.new(self)
    else
      TestingAlgorithm.new(self)
    end
  end

  def image_data_vectors
    test_images.map do |filename|
      unless /\./ =~ filename
        filename += '.raw'
      end
      path = File.absolute_path(File.join(File.split(config.image_index).first, filename))
      image = Image.from_raw(path, 64, 88)
      Vector.new(image.data)
    end
  end

  def epochs
    config.epochs
  end

  def database_path
    config.network_file
  end

  private
  attr_reader :config

  def parse_index_file
    index = File.read(config.image_index).split
    person_count = index.shift.to_i
    image_count = index.shift.to_i

    image_count_for_class = []
    while index.first =~ /^\d*$/
      image_count_for_class << index.shift.to_i
    end
    @image_count_for_class = image_count_for_class.freeze

    unless image_count_for_class.reduce(&:+) == image_count
      raise "Error in index file. Images per class does not add up to total image count"
    end

    @test_images = index.freeze

    unless test_images.count == image_count
      raise "Error. Index file does not describe the correct number of images"
    end

    if config.mode == :learning
      name_regex = /^[a-z]*/
    else # testing
      name_regex = /^[A-Za-z]*/
    end

    people = test_images.map do |filename|
      filename.scan(name_regex).first
    end.uniq

    unless people.count == person_count
      raise "Error. Index file does not describe the correct number of people"
    end
    @people = people.freeze
  end
end
