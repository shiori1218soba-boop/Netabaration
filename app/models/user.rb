class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :nullify

  validates :name, presence: true

  # is_active が false → true に戻ったとき投稿を復元
  before_update :restore_posts_if_reactivated, if: :reactivating?

  # Devise ログイン制御
  def active_for_authentication?
    super && is_active
  end

  def inactive_message
    !is_active? ? :deleted_account : super
  end

  # =====================
  # 論理削除・復活ロジック
  # =====================

  def withdraw!
    transaction do
      update!(is_active: false)
      posts.update_all(deleted_at: Time.current)
    end
  end

  def restore_posts
    posts.where.not(deleted_at: nil).update_all(deleted_at: nil)
  end

  private

  def restore_posts_if_reactivated
    restore_posts
  end

  def reactivating?
    saved_change_to_is_active? && is_active == true
  end
end
