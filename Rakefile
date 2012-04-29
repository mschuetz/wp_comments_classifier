# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "wp_comments_classifier"
  gem.version = "0.0.1.pre"
  gem.homepage = "https://github.com/mschuetz/wp_comments_classifier"
  gem.license = "MIT"
  gem.summary     = 'A comment classifier for Wordpress blogs.'
  gem.description = 'Classifies comments in a wordpress database based on previous classifications using naive bayes.'
  gem.email = "mschuetz@gmail.com"
  gem.authors = ["Matthias Schuetz"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
  test.verbose = true
end

task :default => :test
