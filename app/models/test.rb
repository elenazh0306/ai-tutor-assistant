class Test < ApplicationRecord
  belongs_to :material
  has_many :questions
  has_many :feedbacks
end
