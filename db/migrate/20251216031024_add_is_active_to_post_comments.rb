class AddIsActiveToPostComments < ActiveRecord::Migration[6.1]
  def change
    add_column :post_comments, :is_active, :boolean, default: true, null: false
  end
end
