class Material < ApplicationRecord
  validates :title, presence: true
  belongs_to :subject
end
