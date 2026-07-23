class Subject < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  belongs_to :user
  belongs_to :tutor
  has_many :chats
  has_many :materials
  has_many :tests
end
