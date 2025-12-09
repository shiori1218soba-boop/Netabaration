class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && is_active
  end

  def inactive_message
    "このアカウントは退会済みです"
  end 
         
end
