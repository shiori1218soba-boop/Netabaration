class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :posts, dependent: :destroy

  validates :name, presence: true
end
