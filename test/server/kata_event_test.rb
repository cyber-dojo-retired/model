# frozen_string_literal: true
require_relative 'test_base'

class KataEventTest < TestBase

  def self.id58_prefix
    'Lw2'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1P3', %w( v0 example ) do
    V0_KATA_ID = 'rUqcey'
    actual = kata_event(V0_KATA_ID, 2)
    expected = kata_events_rUqcey_2
    assert_equal kata_events_rUqcey_2, actual
  end

  private

  def print_cmp(expected, actual)
    actual.each do |key,value|
      if expected[key] == actual[key]
        p("key #{key}: SAME")
      else
        p("key #{key}: NOT SAME")
      end
    end
    actual["files"].each do |key,value|
      if expected["files"][key] == actual["files"][key]
        p("key ['files'][#{key}] : SAME")
      else
        p("key ['files'][#{key}] : NOT SAME")
        expected["files"][key].each do |key2,value|
          actual = actual['files'][key2][key]
          if value == actual
            p(" ['files'][#{key}][#{key2}] : SAME")
          else
            p(" ['files'][#{key}][#{key2}] : NOT SAME")
            p('expected')
            p(value)
            p('actual')
            p(actual)
          end
        end
      end
    end
  end

  def kata_events_rUqcey_2
    return {
      "files" => {
        "test_hiker.py" => {
          "content" => "from hiker import global_answer, Hiker\nimport unittest\n\n\nclass TestHiker(unittest.TestCase):\n\n    def test_global_function(self):\n        self.assertEqual(42, global_answer())\n\n    def test_instance_method(self):\n        self.assertEqual(42, Hiker().instance_answer())\n\n    def test_global_function2(self):\n        self.assertEqual(42, global_answer())\n\n    def test_instance_method2(self):\n        self.assertEqual(42, Hiker().instance_answer())\n        \n\nif __name__ == '__main__':\n    unittest.main()  # pragma: no cover\n"
        },
        "hiker.py" => {
          "content" => "'''The starting files are unrelated to the exercise.\n\nThey simply show syntax for writing and testing\n  o) a global function\n  o) an instance method\nPick the style that best fits the exercise.\nThen delete the other one, along with this comment!\n'''\n\ndef global_answer():\n    return 6 * 7\n\nclass Hiker:\n\n    def instance_answer(self):\n        return global_answer()\n"
        },
        "cyber-dojo.sh" => {
          "content" => "set -e\n\n# --------------------------------------------------------------\n# Text files under /sandbox are automatically returned...\nsource ~/cyber_dojo_fs_cleaners.sh\nexport REPORT_DIR=${CYBER_DOJO_SANDBOX}/report\nfunction cyber_dojo_enter()\n{\n  # 1. Only return _newly_ generated reports.\n  cyber_dojo_reset_dirs ${REPORT_DIR}\n}\nfunction cyber_dojo_exit()\n{\n  # 2. Remove text files we don't want returned.\n  cyber_dojo_delete_dirs .pytest_cache # ...\n  #cyber_dojo_delete_files ...\n}\ncyber_dojo_enter\ntrap cyber_dojo_exit EXIT SIGTERM\n# --------------------------------------------------------------\n\ncoverage3 run \\\n  --source=${CYBER_DOJO_SANDBOX} \\\n  --module unittest \\\n  *test*.py\n\n# https://coverage.readthedocs.io/en/v4.5.x/index.html\n\ncoverage3 report \\\n  --show-missing \\\n    > ${REPORT_DIR}/coverage.txt\n\n# http://pycodestyle.pycqa.org/en/latest/intro.html#configuration\n\npycodestyle \\\n  ${CYBER_DOJO_SANDBOX} \\\n    --show-source `# show source code for each error` \\\n    --show-pep8   `# show relevent text from pep8` \\\n    --ignore E302,E305,W293 \\\n    --max-line-length=80 \\\n      > ${REPORT_DIR}/style.txt\n\n# E302 expected 2 blank lines, found 0\n# E305 expected 2 blank lines after end of function or class\n# W293 blank line contains whitespace\n"
        },
        "readme.txt" => {
          "content" => "Write a program that prints the numbers from 1 to 100, but...\n\nnumbers that are exact multiples of 3, or that contain 3, must print a string containing \"Fizz\"\n   For example 9 -> \"...Fizz...\"\n   For example 31 -> \"...Fizz...\"\n\nnumbers that are exact multiples of 5, or that contain 5, must print a string containing \"Buzz\"\n   For example 10 -> \"...Buzz...\"\n   For example 51 -> \"...Buzz...\"\n"
        },
        "report/style.txt" => {
          "content" => ""
        },
        "report/coverage.txt" => {
          "content" => "Name            Stmts   Miss  Cover   Missing\n---------------------------------------------\nhiker.py            5      0   100%\ntest_hiker.py      12      0   100%\n---------------------------------------------\nTOTAL              17      0   100%\n",
          "truncated" => false
        }
      },
      "stdout" => {
        "content" => "",
        "truncated" => false
      },
      "stderr" => {
        "content" => "....\n----------------------------------------------------------------------\nRan 4 tests in 0.000s\n\nOK\n",
        "truncated" => false
      },
      "status" => "0",
      "duration" => 1.891786,
      "colour" => "green",
      "predicted" => "none",
      "index" => 2,
      "time" => [2020,11,30, 14,6,53, 941739]
    }
  end

end
