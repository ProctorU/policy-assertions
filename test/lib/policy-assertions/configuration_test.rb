require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_configuration_exists
    refute_nil PolicyAssertions.config
  end

  def test_seperator
    assert_equal '_and_', PolicyAssertions.config.separator
  end

  def test_ruby_version
    refute_nil PolicyAssertions.config.ruby_version

    assert PolicyAssertions.config.ruby_version > 0
  end
end
