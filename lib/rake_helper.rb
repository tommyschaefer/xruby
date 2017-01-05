module RakeArguments
  # Will take all arguments after the `--` in your Rake command.
  #
  # Given a command such as:
  #     $ rake test hamming wordy
  #
  # Calling Rake.arguments will return:
  #     ["hamming", "wordy"]`
  #
  def arguments
    ARGV.take_while { |e| e != '--' }.drop(1)
  end
end

Rake.extend RakeArguments
