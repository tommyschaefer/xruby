require 'rake'
require 'rake/testtask'

require_relative 'lib/tasks/exercise_test_task'

desc 'rake with no argument will run "rake test:all"'
task default: 'test'

task :test do
  Rake::Task['test:all'].invoke
end

namespace :test do
  desc 'Run all development and exercise tests'
  task :all do
    Rake::Task['test:dev'].invoke
    Rake::Task['test:exercises'].invoke
  end

  Rake::TestTask.new :dev do |task|
    task.pattern = 'test/**/*_test.rb'
  end

  ExerciseTestTask.new :exercise do |task|
    task.description = "Run the tests for a specific exercise"
  end

  desc 'Run the tests for all exercises'
  task :exercises do
    Dir.foreach('exercises').each do |exercise|
      next if %w(. ..).include?(exercise)

      Rake::Task['test:exercise'].execute(exercise: exercise)
    end
  end
end
