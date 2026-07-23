class ChatsController < ApplicationController

  def create
    @subject = Subject.find(params[:subject_id])

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.subject = @subject


    if @chat.save
      redirect_to chat_path(@chat)
    else
      @subject.chats = @chats
      render "challenges/show", status: :unprocessable_entity
    end
  end

  # as a user I can enter a live chat / get / subjects/:id/chats/:id
  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @message = Message.new
  end
end
