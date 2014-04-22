json.array!(@terms) do |term|
  json.extract! term, :id, :title, :content, :active
  json.url term_url(term, format: :json)
end
