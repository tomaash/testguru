require 'test_helper'

class Username:stringTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Username:string.new.valid?
  end
end
