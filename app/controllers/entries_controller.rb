class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_entry, only: [:show, :edit, :update]

  def index
    @entries = Entry.all.paginate(page: params[:page])
  end

  def new
    @entry = current_user.entries.build
  end

  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      redirect_to current_user, notice: "Entry has been created"
    else
      redirect_to root_path
    end
  end

  def show
    @entry = Entry.find_by(id: params[:id])
    @all_comments = @entry.comment_feed
    @comment = @entry.comments.build
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      flash[:notice] = "Update entry successfully"
      redirect_to @entry
    else
      flash[:alert] = "Can not update entry"
      redirect_to root_path
    end
  end

  private
    def set_entry
      @entry = Entry.find_by(id: params[:id])
    end

    def entry_params
      params.require(:entry).permit(:title, :content)
    end

    def correct_user
      # auto send id of entry
      @entry = current_user.entries.find_by(id: params[:id])
      if @entry.nil?
        flash[:alert] = "You do not have right to access this"
        redirect_to root_path
      end
    end
end
