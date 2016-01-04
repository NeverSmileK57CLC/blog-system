class AddTimeEditToComments < ActiveRecord::Migration
  def change
    add_column :comments, :time_edit, :datetime
  end
end
