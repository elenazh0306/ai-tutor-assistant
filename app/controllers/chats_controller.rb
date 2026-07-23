class ChatsController < ApplicationController

  def create
    @subject = Subject.find(params[:subject_id])

    @chat = Chat.new(title: "Untitled")
    @chat.challenge = @challenge
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      @chats = @challenge.chats.where(user: current_user)
      render "challenges/show"
    end
  end
end
