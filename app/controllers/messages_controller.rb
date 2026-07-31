class MessagesController < ApplicationController

  SYSTEM_PROMPT = ""

  def create
    @chat = Chat.find(params[:chat_id])
    @subject = @chat.subject
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @assistant_message = Message.create(role: "assistant", content: "", chat: @chat)

      response = ask_llm
      @assistant_message.update(content: response.content)
      @chat.generate_title_from_first_message

      # for the corrent order of message display
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end

    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end


  private

  def ask_llm
    @ruby_llm_chat = RubyLLM.chat.with_tool(TutorTool.new(tutor:@subject.tutor.name))

    build_conversation_history

    @ruby_llm_chat.with_instructions(instructions).ask(@message.content) do |chunk|
      next if chunk.content.blank? # skip empty chunks

      @assistant_message.content += chunk.content
      broadcast_replace(@assistant_message)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: helpers.dom_id(message), partial: "messages/message", locals: { message: message })
  end

  def build_conversation_history
    @chat.messages.each do |message|
      next if message.content.blank?
      @ruby_llm_chat.add_message(
        role: message.role,
        content: message.content
      )
    end
  end

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
