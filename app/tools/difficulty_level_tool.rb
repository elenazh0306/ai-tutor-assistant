class DifficultyLevelTool < RubyLLM::Tool
  description "Adjust test difficulty to the requested level"

  def initialize(difficulty:)
    @difficulty = difficulty
  end

  def execute

  end
end
