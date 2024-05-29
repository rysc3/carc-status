class AddArchToNodes < ActiveRecord::Migration[6.1]
  def change
    add_column :nodes, :Arch, :string
  end
end
