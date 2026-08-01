class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[show edit update destroy]

  def index
    @subjects = current_user.subjects # Optional: Can be set to 'current_user.subjects' if scoped to logged-in user
  end

  def show
    @chats = @subject.chats
  end

  def new
    create_tutor
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.user = current_user
    if @subject.save
      redirect_to subject_path(@subject)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_tutor
    @ted = Tutor.create(name: "Ted Lasso")
    @dumbledore = Tutor.create(name: "Albus Dumbledore")
    @norbury = Tutor.create(name: "Ms. Norbury")
  end

  def edit
  end

  def update
    if @subject.update(subject_params)
      redirect_to subject_path(@subject)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subject.destroy
    redirect_to subjects_path, status: :see_other
  end

  private

  def set_subject
    @subject = current_user.subjects.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name, :tutor_id)
  end
end
