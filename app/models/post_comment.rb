class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates :comment, presence: true

  scope :active, -> {
    joins(:user, :post)
      .where(
        users: { deleted_at: nil },
        posts: { deleted_at: nil },
        post_comments: { deleted_at: nil }
      )
  }

  def soft_delete
    update(deleted_at: Time.current)
  end
  
  def restore
    update(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end

end
