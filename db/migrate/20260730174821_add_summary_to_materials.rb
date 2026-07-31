class AddSummaryToMaterials < ActiveRecord::Migration[8.1]
  def change
    add_column :materials, :summary, :text
  end
end
