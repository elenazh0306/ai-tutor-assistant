class DifficultyLevelTool < RubyLLM::Tool
  description "Adjust test difficulty to the requested level."

  def initialize(difficulty:)
    @difficulty = difficulty
  end

  def execute
    if @difficulty == "Easy"
      difficulty_prompt = "short and simple questions that require basic understanding of the materials. Questions can be either an open question, answers to which should be 5 words maximum, or a true/false statements (if it is a true/false statement, indicate it in brakets) "
    elsif @difficulty == "Moderate"
      difficulty_prompt = "questions, answers to which should be privided in a few sentances, that require undestanding of the materials and measure a student's ability to apply, analyze or interpret learnt materials"
    elsif @difficulty == "Difficult"
      difficulty_prompt = "questions, answers to which take at least a small paragraph, that require require deep critical thinking, complex multi-step problem solving, and the ability to apply learned concepts to new situations, could be in a form of a small case study or an open question"
    end
  end
end
