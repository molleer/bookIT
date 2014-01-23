json.array!(@rooms) do |room|
  json.extract! room, :id, :name, :festrum
  json.url room_url(room, format: :json)
end
