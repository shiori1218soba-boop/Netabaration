class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments

  
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
  scope :active, -> {
    joins(:user).where(deleted_at: nil, users: { deleted_at: nil })
  }
  # 論理削除（通常の destroy をオーバーライド）
  def soft_delete
    update(deleted_at: Time.current)
  end

  # 復活用（管理者・再アクティブ化用）
  def restore
    update(deleted_at: nil)
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
