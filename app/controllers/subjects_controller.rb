class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  INSTRUCTIONS_FOR_IMAGES = <<~PROMPT
  You are an expert AI image prompt engineer.
  Take the title of the subject and use it as the basis for a clear image prompt for an image that captures the mood and fundamental ideas regarding this subject.

  ## Further Instructions
  If the subject is about mathematics or abstract learning (like geometry), focus on relevant shapes (like triangles or polynomials).
  If the subject falls within the humanities (like history, politics, literature, geography, sociology), focus on scenes that capture the ambiance of the subject's theme.

  ## Restrictions
  Return ONLY the final prompt string.
  Do not include quotes, intro text, or explanations.
  PROMPT

  def index
    @subjects = Subject.all # Optional: Can be set to 'current_user.subjects' if scoped to logged-in user
  end

  def show
    @chats = @subject.chats
  end

  def new
    @subject = Subject.new
    image_generator
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.user = current_user
    @subject.tutor = Tutor.first
    if @subject.save
      redirect_to subject_path(@subject)
    else
      render :new, status: :unprocessable_entity
    end
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
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:name)
  end

  def image_generator
    image_prompt_chat = RubyLLM.chat
    image_prompt = image_prompt_chat.with_instructions(INSTRUCTIONS_FOR_IMAGES).ask(@subject)
    image = RubyLLM.paint(image_prompt, model: "enter-model-name-here")
    # save to the temp folder, so that we can upload to Cloudinary from there
    temp_path = image.save(Rails.root.join("tmp", "temp_subject.jpg"))
    # Upload to Cloudinary and grab the secure web URL
    upload_result = Cloudinary::Uploader.upload(temp_path.to_s)
    # Save the URL to @material
    @subject.image_url = upload_result["secure_url"]
    # Clean up the temporary local file
    File.delete(temp_path) if File.exist?(temp_path)
  end
end
