# require "bundler/gem_tasks"

require 'rubygems/tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

#This gives us build, install, and release
Gem::Tasks.new(:console => false, :sign => false, :scm => false) do |tasks|
    tasks.push.host = 'http://artifacts.scm.tripwire.com:8081/artifactory/api/gems/gems-scm-local'
end
