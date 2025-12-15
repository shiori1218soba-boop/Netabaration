class Post < ApplicationRecord
  belongs_to :user

  
  validates :title, presence: true
  validates :body, presence: true

  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%'+content)
    else
      Post.where('title LIKE ?', '%'+content+'%')
    end
  end

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
