class UpdateNodesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :nodes do |t|
      t.string :NodeName
      t.integer :CoresPerSocket
      t.integer :CPUAlloc
      t.integer :CPUEfctv
      t.integer :CPUTot
      t.float :CPULoad
      t.text :AvailableFeatures
      t.text :ActiveFeatures
      t.text :Gres
      t.string :NodeAddr
      t.string :NodeHostName
      t.string :Version
      t.string :OS
      t.integer :RealMemory
      t.integer :AllocMem
      t.integer :FreeMem
      t.integer :Sockets
      t.integer :Boards
      t.string :State
      t.integer :ThreadsPerCore
      t.integer :TmpDisk
      t.integer :Weight
      t.string :Owner
      t.string :MCS_label
      t.text :Partitions
      t.datetime :BootTime
      t.datetime :SlurmdStartTime
      t.datetime :LastBusyTime
      t.datetime :ResumeAfterTime
      t.text :CfgTRES
      t.text :AllocTRES
      t.string :CapWatts
      t.integer :CurrentWatts
      t.integer :AveWatts
      t.string :ExtSensorsJoules
      t.integer :ExtSensorsWatts
      t.string :ExtSensorsTemp
      t.text :Reason

      # The extra fields
      t.datetime :last_updated
    end
  end
end
