require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'test/**/*_test.rb'
end

namespace :load do
	desc "Load Mpayer to local from Test run for offline testing"
	task :mpayer do
		# Delete current files first
		File.delete(*Dir.glob('lib/mpayer_ruby/support/**/*.json'))
		ENV['LOAD_MPAYER'] = 'true'
		Rake::Task["test"].invoke
	end
end


task :default => :test