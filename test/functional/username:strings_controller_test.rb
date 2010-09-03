require 'test_helper'

class Username:stringsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Username:string.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Username:string.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_edit
    get :edit, :id => Username:string.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Username:string.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Username:string.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Username:string.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Username:string.first
    assert_redirected_to root_url
  end
end
