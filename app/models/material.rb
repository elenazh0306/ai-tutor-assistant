class Material < ApplicationRecord
  belongs_to :subject
  has_many :tests
end
