json.array!(@future_tweets) do |future_tweet|
  json.extract! future_tweet, :id, :message, :post_at, :status
  json.url future_tweet_url(future_tweet, format: :json)
end
