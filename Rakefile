require 'rake'
require 'rake/testtask'

require_relative 'lib/rake_helper'
require_relative 'lib/tasks/exercise_test_task'

task default: 'test'

desc 'Run all development and exercise tests'
task :test do
  exercises = Rake.arguments

  if exercises.any?
    exercises.each do |e|
      task(e) { Rake::Task['test:exercise'].execute(exercise: e) }
    end
  else
    Rake::Task['test:dev'].invoke
    Rake::Task['test:exercises'].invoke
  end
end

namespace :test do
  desc 'Run all development tests located in the test directory'
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
