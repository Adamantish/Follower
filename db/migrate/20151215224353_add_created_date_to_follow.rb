class AddCreatedDateToFollow < ActiveRecord::Migration
  def change
    add_column :follows, :created_datetime, :datetime, null: false
    add_index :follows, :created_datetime
  end
end
