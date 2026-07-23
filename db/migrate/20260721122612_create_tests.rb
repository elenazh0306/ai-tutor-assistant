class CreateTests < ActiveRecord::Migration[8.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
