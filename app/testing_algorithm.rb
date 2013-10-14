require_relative 'algorithm'
require_relative 'ccipca'

class TestingAlgorithm
  def initialize(source)
    @source = source
    load_pca
    @matches = {}
  end

  def run
    puts "#{images.count} images to test"
    images.each_with_index do |image, index|
      @matches[image] = pca.closest_neighbor image.to_vector
      write index, image, @matches[image]
    end
    puts
    output_report
  end

  private
  attr_reader :pca, :source

  def write index, image, match
    File.open("matches/#{index}_image.pgm", 'w') do |file|
      file << image.to_pgm
    end
    File.open("matches/#{index}_match.pgm", 'w') do |file|
      file << match.to_pgm
    end
  end

  def images
    @_images ||= source.images.freeze
  end

  def load_pca
    puts "Loading PCA from #{source.database_path}"
    @pca = CCIPCA.load source.database_path
    puts "Database loaded"
  end

  def output_report
    File.open(output_file, 'w') do |file|
      file.write(report)
    end
  end

  def report
    header + seperator + match_report
  end

  def header
    "Output for pcanet.rb by Grayson Wright
    Testing mode
    Database file: #{source.database_path}
    Testing List: #{source.input_file}"
  end

  def seperator
    "\n"*2
  end

  def match_report
    "Input image -> Matched image (distance)\n" +
      "---------------------------------------\n" +
    (@matches.map do |query, match|
        displacement = query.to_vector - match.to_vector
          "#{query.path} -> #{match.path} (#{displacement.magnitude.round})"
      end.join "\n")
  end

  def output_file
    source.output_file
  end
end
