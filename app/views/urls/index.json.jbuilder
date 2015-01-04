json.array!(@urls) do |url|
  json.extract! url, :id, :path
  json.url url_url(url, format: :json)
end
