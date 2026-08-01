class FeedbacksController < ApplicationController
  SYSTEM_PROMPT = "You are a friendly and encouraging tutor that explains things in a simple manner that is easy to
  understand.

  Display the question number, question, and user answer in this exact format:
  Question Number. Question
  User Answer

  Review every answer separately by comparing the user's answer with the correct answer.

  Next to every answer, add a tickmark for correct answers, triangle for partially correct answers,
  or a cross for incorrect answers.

  Include the following:
  - Explain whether the answer is correct, partially correct, or incorrect.
  - Explain what the user understood well.
  - Explain how the answer could be improved, if there are any improvements to be made.

  Include an 'Overall Feedback' section:
  - Explain what the user's next steps should be and what to review.

  Remove any symbols.

  End the prompt with a short and encouraging message."
  def create
    @test = Test.find(params[:test_id])
    @subject = @test.subject
    @ruby_llm_chat = RubyLLM.chat

    response = @ruby_llm_chat.with_instructions(instructions)
                             .ask(test_results)

    @feedback = @test.feedbacks.new(content: response.content)

    if @feedback.save
      redirect_to test_feedback_path(@test, @feedback)
    else
      render "tests/show", status: :unprocessable_entity
    end
  end

  def show
    @test = Test.find(params[:test_id])
    @subject = @test.subject
    @feedback = @test.feedbacks.find(params[:id])
    @questions = @test.questions
  end

  private

  def instructions
    [SYSTEM_PROMPT].compact.join("\n\n")
  end

  def feedback_params
    params.require(:feedback).permit(:content)
  end

  def test_results
    @test.questions.map.with_index(1) do |question, index|
      "Question #{index}: #{question.title}\n
      Your answer: #{question.answer}"
    end.join("\n\n")
  end
end
