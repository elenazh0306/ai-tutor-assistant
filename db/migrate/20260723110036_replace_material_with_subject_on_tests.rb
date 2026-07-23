class ReplaceMaterialWithSubjectOnTests < ActiveRecord::Migration[8.1]
  def change
    remove_reference :tests, :material, foreign_key: true

    add_reference :tests, :subject, foreign_key: true
  end
end
