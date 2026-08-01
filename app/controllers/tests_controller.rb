class TestsController < ApplicationController

  before_action :set_subject, only: [:index, :show, :new, :create, :destroy]
  before_action :set_test, only: [:show, :destroy]

  QUESTONS_PROMPT = <<~PROMPT
      Generate questions based on the provided materials.
      You are now acting as an assessment generator, not as a tutor.

      Rules:
      - Do not use jokes, metaphors, analogies, stories, or conversational language.
      - Do not reference previous conversations with the student.
      - Do not include encouragement, praise, emojis, or commentary.
      - Produce concise, academically worded questions only.
      - Base every question strictly on the provided materials.
      - Generate EXACTLY the requested number of questions.
      - Never generate more or fewer.
      - Follow the requested difficulty.
      - Return ONLY a JSON array.
      - Every object must have one key: "question".

      Example:
      [
        {"question":"..."},
        {"question":"..."}
      ]
  PROMPT

  def index
    @tests = Test.all
  end

  def show
    @feedback = Feedback.new
    @questions = @test.questions
  end

  def new
    @quantity = params[:question_quantity]
    @difficulty = params[:difficulty]
    if @difficulty == "Easy"
      difficulty_prompt = "short and simple questions that require basic understanding of the materials. Questions can be either an open question, answers to which should be 5 words maximum, or a true/false statements (if it is a true/false statement, indicate it in brakets) "
    elsif @difficulty == "Moderate"
      difficulty_prompt = "questions, answers to which should be privided in a few sentances, that require undestanding of the materials and measure a student's ability to apply, analyze or interpret learnt materials"
    elsif @difficulty == "Difficult"
      difficulty_prompt = "questions, answers to which take at least a small paragraph, that require require deep critical thinking, complex multi-step problem solving, and the ability to apply learned concepts to new situations, could be in a form of a small case study or an open question"
    end

    @materials = @subject.materials.where(id: params[:material])

    @test = Test.new(subject: @subject, title: "#{@subject.name.capitalize} Test : #{@difficulty}", quantity: @quantity, difficulty: @difficulty)

    test_materials = @materials.pluck(:summary).join("\n\n")
    response = RubyLLM.chat
                      .with_instructions(QUESTONS_PROMPT)
                      .ask(<<~PROMPT)
                          Difficulty: #{difficulty_prompt}
                          Number of questions: #{@quantity}

                          Materials:
                          #{test_materials}
                          PROMPT
    @questions_array = JSON.parse(response.content)
    @questions_array.each do |q|
      @test.questions.build(
        title: q["question"]
      )
    end
  end

  def create
    @test = Test.new(test_params)
    @test.subject = @subject

    # redirect to the test page
    if @test.save
      redirect_to subject_test_path(@subject, @test)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy

    @test.destroy

    redirect_to subject_path(@subject), status: :see_other
  end

  private

  def set_subject
    @subject = Subject.find(params[:subject_id])
  end

  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(
      :title,
      questions_attributes: [:id, :title, :answer] )
  end
end
