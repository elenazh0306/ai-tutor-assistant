class NumberOfQuestionsTool < RubyLLM::Tool
  description "Adjust the amount of questions to requested. If the quantity is equal or less than 1, generate 1 question."

  def initialize(quantity:)
    @quantity = quantity
  end

  def execute
    return "#{@quantity} questions"
  end
end
