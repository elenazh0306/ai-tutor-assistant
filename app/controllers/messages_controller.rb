class MessagesController < ApplicationController

  SYSTEM_PROMPT = ""

  def create
    @chat = Chat.find(params[:chat_id])
    @subject = @chat.subject
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)
      @chat.generate_title_from_first_message
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def subject_context
    # left it as a name for now as we do not have content for a subject
    "Here is the context of the subject: #{@subject.name}."
  end

  def instructions
    [SYSTEM_PROMPT, subject_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
