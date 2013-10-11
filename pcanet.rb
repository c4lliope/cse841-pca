# ruby pcanet.rb -l e -f files -d networkfile -o output_file

require_relative 'app/image'
require_relative 'configuration'

config = Configuration.from_options

p config.epochs
p config.image_index
p config.network_file
p config.output_file
p config.mode


