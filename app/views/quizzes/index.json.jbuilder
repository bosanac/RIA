json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :naslov, :opis, :datumstart, :datumstop, :pokusaja
  json.url quiz_url(quiz, format: :json)
end
