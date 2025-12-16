class AddDeletedAtToPostComments < ActiveRecord::Migration[6.1]
  def change
    add_column :post_comments, :deleted_at, :datetime
    add_index  :post_comments, :deleted_at
  end
end
