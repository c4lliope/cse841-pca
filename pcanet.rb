# CSE 841 Homework 2: CCI PCA
# Submission by Grayson Wright
# ============================

# ruby pcanet.rb -l e -f files -d networkfile -o output_file

require_relative 'app/data_source'

`mkdir mef`
config = Configuration.from_options

source = DataSource.new config
algorithm = source.algorithm

algorithm.run
