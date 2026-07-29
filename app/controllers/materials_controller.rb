class MaterialsController < ApplicationController
  before_action :set_subject
  before_action :set_material, only: %i[show edit update destroy]

  # adding a longer, much more detailed prompt
  INSTRUCTIONS_FOR_MATERIALS = <<~PROMPT
    You are an expert tutor creating study notes for a beginner student based on their recent chat session.

    Format your response by using subheaders, bullet points and by bolding key terms. Be sure to include the following in your explanation:

    Core Concepts
    A 2-3 sentence overview of the main topic discussed.

    Key Takeaways as bullet points
    - [Concept Name]: Clear, simple explanation.
    - [Concept Name]: Clear, simple explanation.

    Further suggesstions
    Ask 1-2 short questions based on the chat to inspire the student to think about the next logical learning steps.
    - Here are a few thoughts for you next study session:
    - [Question 1 (Give the Question a Title)]: Clear, simple question.
    - [Question 2 (Give the Question a Title)]: Clear, simple question.

    Rules:
    - Keep explanations beginner-friendly and concise.
    - Avoid meta-talk like "Here is your summary." Jump straight into the content. Do not end with meta-talk.
  PROMPT

  INSTRUCTIONS_FOR_IMAGES = <<~PROMPT
    You are an expert AI image prompt engineer. Take the learning materials supplied and summarize them into a clear image prompt for an image that captures the mood and fundamental ideas regarding the subject.

    ## Further Instructions
    If the subject is about mathematics or abstract learning (like geometry), focus on relevant shapes (like triangles or polynomials).
    If the subject is within the humanities (like history, politics, literature, geography, sociology), focus on scenes that capture the ambiance of the subject's theme.

    ## Restrictions
    Return ONLY the final prompt string.
    Do not include quotes, intro text, or explanations.
  PROMPT

  def index
    @materials = @subject.materials # <-- @materials = Material.all would grab *all* materials in the entire database
  end

  def new
    @material = Material.new(content: params[:content])
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    llm_summary
  end

  def create
    @material = Material.new(material_params)
    @material.subject = @subject
    if @material.save
      redirect_to subject_material_path(@subject, @material)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @material.update(material_params)
      # we enter bother @subject and @material because the path is /subjects/:subject_id/materials/:id
      redirect_to subject_material_path(@subject, @material)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @material.destroy
    redirect_to subject_materials_path(@subject), status: :see_other
  end

  private

  def set_subject
    @subject = Subject.find(params[:subject_id])
  end

  def set_material
    # we find only the materials associated with the current subject
    @material = @subject.materials.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:title, :content)
  end

  def llm_summary
    # LLM for materials content generation
    @ruby_llm_chat = RubyLLM.chat
    @messages_assistant = @messages.where(role: "assistant").map(&:content).join("\n")

    summary = @ruby_llm_chat.with_instructions(INSTRUCTIONS_FOR_MATERIALS).ask(@messages_assistant)

    #     # creating an image based on 'summary'
    #     # call the chat LLM again and feed it the summary.content
    #     # prompt it to reduce summary.content to single line image generation prompt
    #     # take that image prompt as a string variable
    #     # give this variable to RubyLLM.paint as the instrutions
    #     image_prompt_chat = RubyLLM.chat
    #     image_prompt = image_prompt_chat.with_instructions(INSTRUCTIONS_FOR_IMAGES).ask(summary.content)
    #     image = RubyLLM.paint(image_prompt, model: "enter-model-name-here")
    #     # save to the temp folder, so that we can upload to Cloudinary from there
    #     temp_path = image.save(Rails.root.join("tmp", "temp_summary.jpg"))
    #     # Upload to Cloudinary and grab the secure web URL
    #     upload_result = Cloudinary::Uploader.upload(temp_path.to_s)
    #     # Save the URL to @material
    #     @material.image_url = upload_result["secure_url"]
    #     # Clean up the temporary local file
    #     File.delete(temp_path) if File.exist?(temp_path)

    @summary = summary.content
  end
end
