# ruby pcanet.rb -l e -f files -d networkfile -o output_file

require_relative 'app/data_source'

config = Configuration.from_options

source = DataSource.new config
algorithm = source.algorithm

algorithm.run
