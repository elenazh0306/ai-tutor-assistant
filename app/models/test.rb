class Test < ApplicationRecord
  belongs_to :subject
  has_many :questions, dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  accepts_nested_attributes_for :questions
end
