require 'tmpdir'

class ExerciseTestRunner
  def initialize(exercise:, test_options: '')
    @exercise = exercise
    @test_options = test_options
  end

  def run
    Dir.mktmpdir(exercise) do |dir|
      setup_exercise_files_in(dir)

      @output = run_exercise_tests_in(dir)
    end

    @output
  end

  private

  attr_reader :exercise, :test_options

  def setup_exercise_files_in(dir)
    FileUtils.cp_r "exercises/#{exercise}/.", dir
    FileUtils.mv "#{dir}/example.rb", "#{dir}/#{srcfile}.rb"
  end

  def run_exercise_tests_in(dir)
    `ruby -I lib -r disable_skip.rb #{dir}/#{srcfile}_test.rb #{test_options}`
  end

  def srcfile
    @_srcfile ||= exercise.tr('-', '_')
  end
end
