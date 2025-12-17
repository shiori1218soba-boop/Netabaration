class RemoveIsActiveFromPostComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :post_comments, :is_active, :boolean
  end
end
