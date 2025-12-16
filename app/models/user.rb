class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :nullify
  has_many :post_comments

  # 論理削除されていないユーザー
  scope :active, -> { where(deleted_at: nil) }

  validates :name, presence: true

  # Devise ログイン制御
  def active_for_authentication?
    super && deleted_at.nil?
  end

  def inactive_message
    deleted_at.nil? ? super : :deleted_account
  end

  # 検索機能
  def self.search_for(content, method)
    case method
    when 'perfect'
      User.where('name = ? OR introduction = ?', content, content)
    when 'forward'
      User.where('name LIKE ? OR introduction LIKE ?', content + '%', content + '%')
    when 'backward'
      User.where('name LIKE ? OR introduction LIKE ?', '%' + content, '%' + content)
    else
      User.where('name LIKE ? OR introduction LIKE ?', '%' + content + '%', '%' + content + '%')
    end
  end


  # =====================
  # 論理削除・復活ロジック
  # =====================


  # 論理削除
  def destroy
    update(deleted_at: Time.current)
  end

  # 復活用（管理者・再アクティブ化用）
  def restore
    update(deleted_at: nil)
  end

  def active?
    deleted_at.nil?
  end

  def withdraw!
    update(deleted_at: Time.current)
  end

  private

  
end
