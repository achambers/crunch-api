#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/crunch-api'
  t.test_files = FileList['test/lib/**/*_test.rb']
  t.ruby_opts = ['-r./test/test_helper.rb']
  t.verbose = true
end

task :default => :test