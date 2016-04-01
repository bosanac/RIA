require 'test_helper'

class OdgovorsControllerTest < ActionController::TestCase
  setup do
    @odgovor = odgovors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:odgovors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create odgovor" do
    assert_difference('Odgovor.count') do
      post :create, odgovor: { opcija: @odgovor.opcija, tacan: @odgovor.tacan }
    end

    assert_redirected_to odgovor_path(assigns(:odgovor))
  end

  test "should show odgovor" do
    get :show, id: @odgovor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @odgovor
    assert_response :success
  end

  test "should update odgovor" do
    patch :update, id: @odgovor, odgovor: { opcija: @odgovor.opcija, tacan: @odgovor.tacan }
    assert_redirected_to odgovor_path(assigns(:odgovor))
  end

  test "should destroy odgovor" do
    assert_difference('Odgovor.count', -1) do
      delete :destroy, id: @odgovor
    end

    assert_redirected_to odgovors_path
  end
end
