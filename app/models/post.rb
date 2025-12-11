class Post < ApplicationRecord
  belongs_to :user

  
  validates :title, presence: true
  validates :body, presence: true


  # 論理削除されていないものだけを取得するスコープ
  scope :active, -> { where(deleted_at: nil) }

  # 論理削除（通常の destroy をオーバーライド）
  def destroy
    update(deleted_at: Time.current)
  end

  # 完全削除（必要なときに使う）
  def really_destroy!
    super.destroy
  end

  # 論理削除判定
  def deleted?
    deleted_at.present?
  end
end
