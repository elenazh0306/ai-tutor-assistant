class AddDifficultyToTest < ActiveRecord::Migration[8.1]
  def change
    add_column :tests, :difficulty, :string
  end
end
