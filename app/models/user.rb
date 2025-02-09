class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :phone, presence: true

  scope :active, -> { where(status: "active") }

  has_many :tasks, dependent: :destroy
end
