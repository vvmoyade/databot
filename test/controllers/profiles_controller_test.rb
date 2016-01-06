require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { avgSessionDuration: @profile.avgSessionDuration, conversions: @profile.conversions, mywebsite_id: @profile.mywebsite_id, name: @profile.name, newUsers: @profile.newUsers, pageviews: @profile.pageviews, profile_index: @profile.profile_index, sessions: @profile.sessions, totalEvents: @profile.totalEvents, users: @profile.users }
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile" do
    patch :update, id: @profile, profile: { avgSessionDuration: @profile.avgSessionDuration, conversions: @profile.conversions, mywebsite_id: @profile.mywebsite_id, name: @profile.name, newUsers: @profile.newUsers, pageviews: @profile.pageviews, profile_index: @profile.profile_index, sessions: @profile.sessions, totalEvents: @profile.totalEvents, users: @profile.users }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end

    assert_redirected_to profiles_path
  end
end
