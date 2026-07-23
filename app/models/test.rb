class Test < ApplicationRecord
  belongs_to :subject
  has_many :questions
  has_many :feedbacks
end
