json.array!(@odgovors) do |odgovor|
  json.extract! odgovor, :id, :opcija, :tacan
  json.url odgovor_url(odgovor, format: :json)
end
