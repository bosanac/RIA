json.array!(@questions) do |question|
  json.extract! question, :id, :string
  json.url question_url(question, format: :json)
end
