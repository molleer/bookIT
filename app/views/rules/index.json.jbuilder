json.array!(@whitelist_items) do |whitelist_item|
  json.extract! whitelist_item, :id, :title, :begin_date, :end_date
  json.url whitelist_item_url(whitelist_item, format: :json)
end
