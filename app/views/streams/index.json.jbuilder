json.array!(@streams) do |stream|
  json.extract! stream, :id, :content, :c2, :post_id, :stream_type, :account_id, :remote_url, :remote_id, :parent, :read, :posted_at
  json.url stream_url(stream, format: :json)
end
