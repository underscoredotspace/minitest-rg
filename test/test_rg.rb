gem "minitest"
require "minitest/autorun"
require "minitest/rg"

class TestRG < Minitest::Test
  def test_pass_is_green
    output = capture_output "pass"

    exp_dot = "\e[32m.\e[0m"
    exp_sum = "\e[32m1 runs, 1 assertions, 0 failures, 0 errors, 0 skips\e[0m"

    assert_match exp_dot, output, "Passing tests are GREEN"
    assert_match exp_sum, output, "Passing summary is GREEN"
  end

  def test_fail_is_red
    output = capture_output "fail"

    exp_dot = "\e[31mF\e[0m"
    exp_sum = "\e[31m1 runs, 1 assertions, 1 failures, 0 errors, 0 skips\e[0m"

    assert_match exp_dot, output, "Failing tests are RED"
    assert_match exp_sum, output, "Failing summary is RED"
  end

  def test_error_is_yellow
    output = capture_output "error"

    exp_dot = "\e[33mE\e[0m"
    exp_sum = "\e[31m1 runs, 0 assertions, 0 failures, 1 errors, 0 skips\e[0m"

    assert_match exp_dot, output, "Erroring tests are YELLOW"
    assert_match exp_sum, output, "Erroring summary is YELLOW"
  end

  def test_skip_is_cyan
    output = capture_output "skip"

    exp_dot = "\e[36mS\e[0m"
    exp_sum = "\e[32m1 runs, 0 assertions, 0 failures, 0 errors, 1 skips\r\n" \
              "\r\nYou have skipped tests. Run with --verbose for details.\e[0m"

    assert_match exp_dot, output, "Skipped tests are CYAN"
    assert_match exp_sum, output, "Skipped summary is CYAN"
  end

  def capture_output command
    os = `uname -s`.chomp
    if os.include?("BSD") || os.include?("Darwin")
      `script -q /dev/null ./scripts/run_#{command}`
    else
      `script -q -c ./scripts/run_#{command} /dev/null`
    end
  end
end
