class Material < ApplicationRecord
  validates :title, presence: true
  belongs_to :subject
  has_rich_text :content
end
