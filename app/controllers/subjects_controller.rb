class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    @chats = @subject.chats
  end
end
