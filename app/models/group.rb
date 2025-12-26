class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :posts, dependent: :destroy

  validates :name, :introduction, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  default_scope { where(deleted_at: nil) }

  def soft_delete
    transaction do
      update!(deleted_at: Time.current)
      posts.update_all(deleted_at: Time.current)
    end
  end

  def restore
    transaction do
      update!(deleted_at: nil)
      posts.unscoped.update_all(deleted_at: nil)
    end
  end

  def deleted
    deleted_at.present?
  end

end
