class Question < ApplicationRecord
  belongs_to :test
  has_one :subject, through: :test
end
