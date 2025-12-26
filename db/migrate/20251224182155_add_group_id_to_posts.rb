class AddGroupIdToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :group, null: true, foreign_key: true
  end
end
