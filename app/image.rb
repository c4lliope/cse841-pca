class Image
  def initialize data, width, height
    @data = data
    @height = height
    @width = width
  end

  def self.from_pgm filepath
    File.open(filepath) do |file|
      header = file.readline
      unless header =~ /P5/
        raise 'Invalid PGM format. This program only accepts P5'
      end
      column_count, row_count = file.readline.split.map(&:to_i)
      file.readline
      data = file.read.unpack("C*")
      Image.new data, column_count, row_count
    end
  end

  def to_pgm
    output = "P5\n"
    output << "#{width} #{height}\n"
    output << "255\n"
    output << data.pack("C*")
    output
  end

  def to_raw
    data.pack("C*")
  end

  def self.from_raw filepath, width, height
    File.open(filepath) do |file|
      data = file.read.unpack("C*")
      Image.new data, width, height
    end
  end

  def rows
    @_rows ||= (0...height).to_a.map do |row|
      data[row * width...(row+1)*width]
    end
  end
  attr_reader :data, :height, :width
end
