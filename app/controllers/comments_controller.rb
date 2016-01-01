class CommentsController < ApplicationController
  before_action :correct_user, only: [:create]
  before_action :set_entry, only: [:create]

  def create
    @comment = @entry.comments.build(comment_params)
    respond_to do |format|
      if !@comment.save
        flash[:alert] = "You can not comment"
      end
      format.html { redirect_to @entry }
      format.js { @all_comments = @entry.comment_feed }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id)
    end

    def set_entry
      @entry = Entry.find_by(id: params[:comment][:entry_id])
    end

    def correct_user
      set_entry
      unless @entry.user.followers.include?current_user or current_user == @entry.user
        redirect_to @entry, alert: "You can not comment in this"
      end
    end
end
