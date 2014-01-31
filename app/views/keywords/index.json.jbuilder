json.array!(@keywords) do |keyword|
  json.extract! keyword, :id, :phrase, :priority, :client_id
  json.url keyword_url(keyword, format: :json)
end
