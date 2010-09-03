require 'test_helper'
 
class Backend::AnswersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:answers)
  end
 
  test "should get new" do
    get :new
    assert_response :success
  end
 
  test "should create answer" do
    assert_difference('Answer.count') do
      post :create, :answer => { }
    end
 
    assert_redirected_to answer_path(assigns(:answer))
  end
 
  test "should show answer" do
    get :show, :id => answers(:one).id
    assert_response :success
  end
 
  test "should get edit" do
    get :edit, :id => answers(:one).id
    assert_response :success
  end
 
  test "should update answer" do
    put :update, :id => answers(:one).id, :answer => { }
    assert_redirected_to answer_path(assigns(:answer))
  end
 
  test "should destroy answer" do
    assert_difference('Answer.count', -1) do
      delete :destroy, :id => answers(:one).id
    end
 
    assert_redirected_to answers_path
  end
end