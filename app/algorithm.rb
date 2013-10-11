class Algorithm
  def initialize(data_source)
    @source = data_source
  end

  protected
  attr_reader :source
end
