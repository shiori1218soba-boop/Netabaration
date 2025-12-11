class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :nullify

  # is_active が false → true に変わるとき投稿も復帰
  before_update :restore_posts_if_reactivated, if: :saved_change_to_is_active?

  # Devise: ログイン可否判定（is_active が false のときログイン不可）
  def active_for_authentication?
    super && is_active
  end

  def inactive_message
    if !is_active?
      :deleted_account
    else
      super
    end
  end

  def restore_posts
    posts.where.not(deleted_at: nil).update_all(deleted_at: nil)
  end
         
end
