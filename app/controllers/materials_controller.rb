class MaterialsController < ApplicationController
  before_action :set_subject
  before_action :set_material, only: %i[show edit update destroy]

INSTRUCTIONS_FOR_MATERIALS = "generate learning materials for a complete beginner from provided text"

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
    # We have to convert params[:content] to a string or ActionText will throw an error
    @material = Material.new(content: params[:content].to_s)
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    llm_summary
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    @material = Material.new(subject: @subject)

    # Get the AI inputs
    llm_summary

    # Initiate the save
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

    # Get the AI-input and assign it to a variable
    summary = @ruby_llm_chat.with_instructions(INSTRUCTIONS_FOR_MATERIALS).ask(@messages_assistant)
    # Convert the summary text into HTML-format
    html_content = Kramdown::Document.new(summary.content).to_html
    # Link the material content to the html content created by the 'Kramdown' markup gem
    @material.content = html_content
    # Generate the title of the materials
    @material.generate_title_from_summary(summary.content)
    @title = @material.title
  end
end
