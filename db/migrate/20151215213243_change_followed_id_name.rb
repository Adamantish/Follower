class ChangeFollowedIdName < ActiveRecord::Migration
  def change
    rename_column :follows, :followed_id, :followee_id
  end
end
