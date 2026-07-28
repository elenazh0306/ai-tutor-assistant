class MaterialsController < ApplicationController
  before_action :set_subject
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  INSTRUCTIONS_FOR_MATERIALS = "generate learning materials for a complete beginner from provided text"

  def index
    @materials = @subject.materials # <-- @materials = Material.all would grab *all* materials in the entire database
  end



  def new
    @material = Material.new(content: params[:content])
    @chat = Chat.find(params[:chat_id])
    @messages = @chat.messages
    llm_summary
  end

  def llm_summary
    # LLM for materials content generation
    @ruby_llm_chat = RubyLLM.chat
    @messages_assistant = @messages.where(role: "assistant").map(&:content).join("\n")

    summary = @ruby_llm_chat.with_instructions(INSTRUCTIONS_FOR_MATERIALS).ask(@messages_assistant)
    # Pass summary through Kramdown in the new method or view
    @summary = Kramdown::Document.new(summary.content).to_html
  end


  def create
    # Convert the incoming markdown parameter into HTML
    html_content = Kramdown::Document.new(material_params[:content]).to_html
    # Create the new Material
    @material = Material.new(material_params)
    # Link the material content to the html content created by the 'Kramdown' markup gem
    @material.content = html_content
    # Link the Material to its Subject
    @material.subject = @subject
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
end
