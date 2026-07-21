class CreateMaterials < ActiveRecord::Migration[8.1]
  def change
    create_table :materials do |t|
      t.string :title
      t.string :content
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
