class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.references :test, null: false, foreign_key: true

      t.timestamps
    end
  end
end
