json.array!(@clients) do |client|
  json.extract! client, :id, :first_name, :last_name, :company, :address, :phone, :alternate_phone, :notes
  json.url client_url(client, format: :json)
end
