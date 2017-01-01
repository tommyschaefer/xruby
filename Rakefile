require 'rake'
require 'rake/testtask'

desc 'rake with no argument will run "rake test:all"'
task default: 'test:all'

namespace :test do
  task :all do
    Rake::Task['test:dev'].invoke
    Rake::Task['test:assignments'].invoke
  end

  Rake::TestTask.new :dev do |task|
    task.pattern = 'test/**/*_test.rb'
  end

  task :assignment, [:assignment] do |_, args|
    assignment = args[:assignment]
    srcfile = assignment.tr('-', '_')

    puts "\n\n#{'-'*64}\nrunning tests for: #{assignment}"

    Dir.mktmpdir(assignment) do |out_dir|
      FileUtils.cp_r "exercises/#{assignment}/.", out_dir
      FileUtils.mv "#{out_dir}/example.rb", "#{out_dir}/#{srcfile}.rb"

      # TODO: Allow args to be passed to tests
      puts `ruby -I lib -r disable_skip.rb #{out_dir}/#{srcfile}_test.rb`
    end
  end

  task :assignments do
    Dir.foreach('exercises').each do |assignment|
      next if %w(. ..).include?(assignment)

      Rake::Task['test:assignment'].execute(assignment: assignment)
    end
  end
end
