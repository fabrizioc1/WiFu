require 'rake'
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new('spec') do |t|
  #t.rcov = true
  t.rspec_opts = ["--color", "--format", "documentation"]
end