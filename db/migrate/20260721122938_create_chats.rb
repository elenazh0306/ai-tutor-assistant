class CreateChats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats do |t|
      t.string :title
      t.references :subject, null: false, foreign_key: true
      t.references :feedback, null: true, foreign_key: true

      t.timestamps
    end
  end
end
