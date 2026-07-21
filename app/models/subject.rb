class Subject < ApplicationRecord
  belongs_to :user
  belongs_to :tutor
  has_many :chats
  has_many :materials
end
