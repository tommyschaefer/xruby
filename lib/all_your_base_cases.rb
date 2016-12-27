class AllYourBaseCase < OpenStruct
  def test_name
    'test_%s' % description.downcase.tr(' -', '_')
  end

  def workload
    (
      [
        "digits = #{input_digits}",
        indent(4, "input_base = #{input_base}"),
        indent(4, "output_base = #{output_base}"),
      ] + assertion
    ).join("\n")
  end

  def skipped
    index.zero? ? '# skip' : 'skip'
  end

  private

  def indent(size, lines)
    lines.lines.each_with_object('') { |line, obj| obj << ' ' * size + line }
  end

  def assertion
    return error_assertion unless expected

    [
      indent(4, "expected = #{expected}"),
      "",
      indent(4, "converted = BaseConverter.convert(input_base, digits, output_base)"),
      "",
      indent(4, "assert_equal expected, converted,"),
      indent(17, error_message)
    ]
  end

  def error_message
    [
      '"Input base: #{input_base}, output base #{output_base}. " \\',
      '"Expected #{expected} but got #{converted}."',
    ].join("\n")
  end

  def error_assertion
    [
      "",
      indent(4, "assert_raises ArgumentError do"),
      indent(6, "BaseConverter.convert(input_base, digits, output_base)"),
      indent(4, "end"),
    ]
  end
end

class AllYourBaseCase::PreProcessor
  class << self
    def call(row)
      @row = row

      row.merge('expected' => expected_value)
    end

    private

    attr_reader :row

    def expected_value
      return row['expected'] if row['expected']

      if invalid_input_digits? || invalid_bases?
        nil
      elsif row['input_digits'].empty?
        []
      elsif input_of_zero?
        [0]
      else
        handle_special_cases
      end
    end

    def invalid_input_digits?
      row['input_digits'].any? { |x| x < 0 || x >= row['input_base'] }
    end

    def invalid_bases?
      row['input_base'] <= 1 || row['output_base'] <= 1
    end

    def input_of_zero?
      row['input_digits'].all? { |x| x == 0 }
    end

    def handle_special_cases
      [4,2] if row['input_digits'] == [0, 6, 0]
    end
  end
end

AllYourBaseCases = proc do |data|
  JSON.parse(data)['cases'].map.with_index do |row, i|
    AllYourBaseCase.new(
      AllYourBaseCase::PreProcessor.call(row).merge(index: i),
    )
  end
end
