require 'test_helper'

class NewappsControllerTest < ActionController::TestCase
  setup do
    @newapp = newapps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:newapps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create newapp" do
    assert_difference('Newapp.count') do
      post :create, newapp: { data: @newapp.data, id: @newapp.id, name: @newapp.name, value: @newapp.value }
    end

    assert_redirected_to newapp_path(assigns(:newapp))
  end

  test "should show newapp" do
    get :show, id: @newapp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @newapp
    assert_response :success
  end

  test "should update newapp" do
    put :update, id: @newapp, newapp: { data: @newapp.data, id: @newapp.id, name: @newapp.name, value: @newapp.value }
    assert_redirected_to newapp_path(assigns(:newapp))
  end

  test "should destroy newapp" do
    assert_difference('Newapp.count', -1) do
      delete :destroy, id: @newapp
    end

    assert_redirected_to newapps_path
  end
end
