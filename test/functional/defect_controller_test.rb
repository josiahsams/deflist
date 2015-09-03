require File.dirname(__FILE__) + '/../test_helper'
require 'defect_controller'

# Re-raise errors caught by the controller.
class DefectController; def rescue_action(e) raise e end; end

class DefectControllerTest < Test::Unit::TestCase
  def setup
    @controller = DefectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
