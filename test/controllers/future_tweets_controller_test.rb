require 'test_helper'

class FutureTweetsControllerTest < ActionController::TestCase
  setup do
    @future_tweet = future_tweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:future_tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create future_tweet" do
    assert_difference('FutureTweet.count') do
      post :create, future_tweet: { message: @future_tweet.message, post_at: @future_tweet.post_at, status: @future_tweet.status }
    end

    assert_redirected_to future_tweet_path(assigns(:future_tweet))
  end

  test "should show future_tweet" do
    get :show, id: @future_tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @future_tweet
    assert_response :success
  end

  test "should update future_tweet" do
    patch :update, id: @future_tweet, future_tweet: { message: @future_tweet.message, post_at: @future_tweet.post_at, status: @future_tweet.status }
    assert_redirected_to future_tweet_path(assigns(:future_tweet))
  end

  test "should destroy future_tweet" do
    assert_difference('FutureTweet.count', -1) do
      delete :destroy, id: @future_tweet
    end

    assert_redirected_to future_tweets_path
  end
end
