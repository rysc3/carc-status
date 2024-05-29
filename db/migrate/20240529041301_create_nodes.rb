class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.string :name
      t.integer :node_id

      t.timestamps
    end
  end
end
