class TestsController < ApplicationController

  before_action :set_subject, only: [:index, :show, :new, :create, :destroy]
  before_action :set_test, only: [:show, :destroy]

  QUESTION_PROMPT = "You are a friendly examiner. Test the user's understanding of by generating 5 short questions in the form of a JSON array with a key 'question' and based on the following input:"

  def index
    @tests = Test.all
  end

  def show
    @feedback = Feedback.new
    @questions = @test.questions
  end

  def new
    @test = Test.new(subject: @subject, title: "#{@subject.name} Test")
    test_materials = @subject.materials.pluck(:content).join("\n\n")
    response = RubyLLM.chat.with_instructions(QUESTION_PROMPT).ask(test_materials)
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
