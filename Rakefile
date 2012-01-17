# Load all tasks under lib/tasks
lib = File.expand_path('../lib/', __FILE__)
$: << lib unless $:.include?(lib)
require 'bundler/setup'
Dir[File.expand_path('../lib/tasks/*.rake',__FILE__)].map{|file| load file}