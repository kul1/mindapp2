require "test_helper"

class MindappTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mindapp::VERSION
  end
end
