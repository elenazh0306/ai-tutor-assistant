class Tutor < ApplicationRecord
  has_many :subjects, dependent: :destroy
end
