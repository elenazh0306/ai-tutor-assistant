class Material < ApplicationRecord
  validates :title, presence: true
  belongs_to :subject
  has_rich_text :content

  # creating a title for the materials automatically with the LLM
  DEFAULT_TITLE = "New Materials"
  TITLE_PROMPT = <<~PROMPT
    "You are a title generator. Read the provided summary of a chat conversation,
      and return a concise, accurate 3-5 word title for this study material.
      Return ONLY the title text, no quotes."
  PROMPT

  def generate_title_from_summary(summary_text)
    return unless title.blank? || title == DEFAULT_TITLE
    return if summary_text.blank?
    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(summary_text)
    # our new material has not been saved to the DB yet, so we must use self.title
    self.title = response.content.strip
  end
end
