module QuestionsHelper
  def getNazivKviza(quiz_id)
    @kviz = User.find(quiz_id);
    @kviz.name
  end
end
