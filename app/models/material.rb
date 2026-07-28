class Material < ApplicationRecord
  belongs_to :subject
  has_rich_text :content
end
