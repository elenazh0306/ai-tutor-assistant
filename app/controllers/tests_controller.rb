class TestsController < ApplicationController
  def index
    @subject = Subject.find(params[:subject_id])
    @tests = Test.all
  end

  def show
    @subject = Subject.find(params[:subject_id])
    @test = Test.find(params[:id])
  end

  def new
    @subject = Subject.find(params[:subject_id])
    @test = Test.new
  end

  def create
    @subject = Subject.find(params[:subject_id])
    @test = @subject.tests.new(test_params)
    if @test.save
      redirect_to subject_test_path(@subject, @test) # Placeholder for now. Redirects to the feedback page to be created later.
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @test = Test.find(params[:id])
    @test.destroy

    redirect_to subject_tests_path, status: :see_other
  end

  private

  def test_params
    params.require(:test).permit(:title)
  end
end
