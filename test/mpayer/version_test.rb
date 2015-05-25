require 'test_helper'

class TestMpayerVersion < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mpayer::VERSION
  end
end