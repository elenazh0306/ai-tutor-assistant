class Subject < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  belongs_to :user
  belongs_to :tutor
  has_many :chats, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :tests, dependent: :destroy
end
