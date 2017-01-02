require 'rake'
require 'rake/testtask'

require_relative 'lib/tasks/exercise_test_task'

desc 'rake with no argument will run "rake test:all"'
task default: 'test:all'

namespace :test do
  desc 'Run all development and exercise tests'
  task :all do
    Rake::Task['test:dev'].invoke
    Rake::Task['test:assignments'].invoke
  end

  Rake::TestTask.new :dev do |task|
    task.pattern = 'test/**/*_test.rb'
  end

  ExerciseTestTask.new :assignment do |task|
    task.description = "Run the tests for a specific exercise"
  end

  desc 'Run the tests for all exercises'
  task :assignments do
    Dir.foreach('exercises').each do |assignment|
      next if %w(. ..).include?(assignment)

      Rake::Task['test:assignment'].execute(assignment: assignment)
    end
  end
end
