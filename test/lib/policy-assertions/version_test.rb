require 'test_helper'

class VersionTest < Minitest::Test
  def test_must_be_defined
    refute_nil PolicyAssertions::VERSION
  end
end
