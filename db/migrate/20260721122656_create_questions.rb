class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :answer
      t.references :test, null: false, foreign_key: true

      t.timestamps
    end
  end
end
