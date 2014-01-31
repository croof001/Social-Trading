json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :author, :message, :author_link, :message_link, :posted_at
  json.url tweet_url(tweet, format: :json)
end
