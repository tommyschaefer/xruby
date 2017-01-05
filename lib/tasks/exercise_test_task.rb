require "rake/tasklib"
require 'tmpdir'

class ExerciseTestTask < Rake::TaskLib
  attr_accessor :name, :description

  def initialize(name)
    @name = name
    @description = description

    yield self if block_given?

    define
  end

  def define
    desc description
    task name, [:exercise] do |_, args|
      @exercise = args[:exercise]

      puts "\n\n#{'-'*64}\nrunning tests for: #{exercise}"

      Dir.mktmpdir(exercise) do |dir|
        setup_exercise_files_in(dir)
        run_exercise_tests_in(dir)
      end
    end
  end

  private

  attr_reader :exercise

  def srcfile
    exercise.tr('-', '_')
  end

  def setup_exercise_files_in(dir)
    FileUtils.cp_r "exercises/#{exercise}/.", dir
    FileUtils.mv "#{dir}/example.rb", "#{dir}/#{srcfile}.rb"
  end

  def run_exercise_tests_in(dir)
    ruby "-I lib -r disable_skip.rb #{dir}/#{srcfile}_test.rb #{test_options}"
  end

  def test_options
    return '' unless ARGV.include?('--')

    ARGV.drop_while { |e| e != '--' }.drop(1).join(' ')
  end
end
