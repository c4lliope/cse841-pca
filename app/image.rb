class Image
  def initialize height, width
    @height = height
    @width = width
  end

  def self.from_pgm filepath
    file = File.open filepath
    file.readline
    column_count, row_count = file.readline.split.map(&:to_i)
    Image.new row_count, column_count
  end

  attr_reader :height, :width
end
