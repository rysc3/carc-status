class CreateNodes < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.string :NodeName
      t.integer :CoresPerSocket
      t.integer :CPUAlloc
      t.float :CPULoad
      t.integer :RealMemory
      t.integer :AllocMem
      t.integer :FreeMem
      t.integer :Sockets
      t.integer :Boards
      t.string :State
      t.integer :ThreadsPerCore
      t.text :Partitions
      t.integer :CurrentWatts
      t.integer :AveWatts

      t.timestamps
    end
  end
end
