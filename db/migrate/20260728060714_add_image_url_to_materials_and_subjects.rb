class AddImageUrlToMaterialsAndSubjects < ActiveRecord::Migration[8.1]
  def change
    add_column :materials, :image_url, :string
    add_column :subjects, :image_url, :string
  end
end
