class Comment < ActiveRecord::Base
  belongs_to :entry
  belongs_to :user
  validates :content, presence: true
  validates :user_id, presence: true
  default_scope -> { order(:created_at => :desc)}
  before_update :set_time_edit

  def set_time_edit
    self.time_edit = Time.zone.now
  end
end
