class Chat < ApplicationRecord
  belongs_to :subject
  belongs_to :feedback, optional: true
end
