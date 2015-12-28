class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_entry, only: [:show, :edit]
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
  end

  def edit
  end

  def update
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
      redirect_to root_path if @entry.nil?
    end
end