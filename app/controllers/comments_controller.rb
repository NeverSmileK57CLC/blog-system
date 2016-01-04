class CommentsController < ApplicationController
  before_action :correct_user, only: [:create]
  before_action :set_entry, only: [:create]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :edit_permission, only: [:edit, :update, :destroy]

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

  def edit
    @entry = @comment.entry
    @all_comments = @entry.comment_feed
  end

  def update
    if @comment.update(comment_params)
      flash[:notice] = "Edit comment successfully"
    else
      flash[:alert] = "Can not edit comment"
    end
    redirect_to @comment.entry
  end

  def destroy
    @entry = @comment.entry
    if @comment.destroy
      flash[:notice] = "You deleted comment"
    else
      flash[:alert] = "You can not delete this comment"
    end
    redirect_to @entry
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :user_id)
    end

    def set_entry
      @entry = Entry.find_by(id: params[:comment][:entry_id])
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    def correct_user
      set_entry
      unless @entry.user.followers.include?current_user or current_user == @entry.user
        redirect_to @entry, alert: "You can not comment in this"
      end
    end

    def edit_permission
      set_comment
      unless current_user == @comment.user
        redirect_to @comment.entry, alert: "You can not edit this comment"
      end
    end
end
