class CommentsController < ApplicationController
  def create
    @entry = Entry.find_by(id: params[:comment][:entry_id])
    @comment = @entry.comments.build(comment_params)
    if !@comment.save
      flash[:alert] = "You can not comment"
    end
    redirect_to @entry
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
