class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    @chats = @challenge.chats.where(user: current_user)
  end
end
