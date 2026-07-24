class TestsController < ApplicationController
  before_action :set_subject, only: [:index, :show, :edit, :update]
  before_action :set_test, only: [:show, :destroy]

  def index
    @tests = Test.all
  end

  # creating an instance of Feedback, which will be used in the form on the test-view-page
  def show
    @feedback = Feedback.new
  end

  def new
    @test = Test.new
  end

# new create action here
  def create
    # gather all the learning materials in one spot
    test_materials = @subject.materials.pluck(:content).join("\n\n")
    # create and save the parent Test
    @test = Test.new(subject: @subject, title: "#{@subject.name} Test")
    # the system prompt
    system_prompt = "You are a friendly examiner. Test the user's understanding of by generating 5 short questions in the form of a JSON array and based on the following input:"
    # get the LLM response
    response = RubyLLM.chat.with_instructions(system_prompt).ask(test_materials)
    # parse the response to get the individual questions and loop through the result
    questions_array = JSON.parse(response.content)
    questions_array.each do |question|
      Question.create!(test: @test, content: question_text)
    end
    # redirect to the test page
    redirect_to test_path(@test)
  end

  def destroy
    @test.destroy

    redirect_to subject_tests_path, status: :see_other
  end

  private

  def set_subject
    @subject = Subject.find(params[:subject_id])
  end

  def set_test
    @test = Test.find(params[:id])
  end

  def test_params
    params.require(:test).permit(:title)
  end
end
