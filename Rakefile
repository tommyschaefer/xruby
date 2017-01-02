require 'rake'
require 'rake/testtask'
require 'tmpdir'

require_relative './lib/exercise_test_runner'

desc 'rake with no argument will run "rake test:all"'
task default: 'test:all'

namespace :test do
  task :all do
    Rake::Task['test:dev'].invoke
    Rake::Task['test:assignments'].invoke
  end

  Rake::TestTask.new :dev do |task|
    task.pattern = 'test/*_test.rb'
  end

  task :assignment, [:assignment] do |_, args|
    runner = ExerciseTestRunner.new(
      exercise: args[:assignment],
      test_options: ENV['TESTOPTS'],
    )

    puts "\n\n#{'-'*64}\nrunning tests for: #{args[:assignment]}"
    puts runner.run
  end

  task :assignments do
    Dir.foreach('exercises').each do |assignment|
      next if %w(. ..).include?(assignment)

      Rake::Task['test:assignment'].execute(assignment: assignment)
    end
  end
end
