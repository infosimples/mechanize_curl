# frozen_string_literal: true
require 'mechanize_curl/test_case'

class TestMechanizeFormImageButton < MechanizeCurl::TestCase

  def test_query_value
    button = MechanizeCurl::Form::ImageButton.new 'name' => 'image_button'

    assert_equal [%w[image_button.x 0], %w[image_button.y 0]],
                 button.query_value
  end
end

