class AddQuantityToTest < ActiveRecord::Migration[8.1]
  def change
    add_column :tests, :quantity, :integer
  end
end
