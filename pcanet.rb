# ruby pcanet.rb -l e -f files -d networkfile -o output_file

require_relative 'app/data_source'

config = Configuration.from_options

source = DataSource.new config
p source.people
p source.image_count_for_class
p source.test_images
