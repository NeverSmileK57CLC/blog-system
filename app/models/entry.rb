class Entry < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(:created_at => :desc)}

  def comment_feed
    Comment.where("entry_id = ?", id)
  end
end
