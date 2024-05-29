# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_05_29_165301) do

  create_table "nodes", force: :cascade do |t|
    t.string "NodeName"
    t.integer "CoresPerSocket"
    t.integer "CPUAlloc"
    t.integer "CPUEfctv"
    t.integer "CPUTot"
    t.float "CPULoad"
    t.text "AvailableFeatures"
    t.text "ActiveFeatures"
    t.text "Gres"
    t.string "NodeAddr"
    t.string "NodeHostName"
    t.string "Version"
    t.string "OS"
    t.integer "RealMemory"
    t.integer "AllocMem"
    t.integer "FreeMem"
    t.integer "Sockets"
    t.integer "Boards"
    t.string "State"
    t.integer "ThreadsPerCore"
    t.integer "TmpDisk"
    t.integer "Weight"
    t.string "Owner"
    t.string "MCS_label"
    t.text "Partitions"
    t.datetime "BootTime"
    t.datetime "SlurmdStartTime"
    t.datetime "LastBusyTime"
    t.datetime "ResumeAfterTime"
    t.text "CfgTRES"
    t.text "AllocTRES"
    t.string "CapWatts"
    t.integer "CurrentWatts"
    t.integer "AveWatts"
    t.string "ExtSensorsJoules"
    t.integer "ExtSensorsWatts"
    t.string "ExtSensorsTemp"
    t.text "Reason"
    t.datetime "last_updated"
    t.string "Arch"
  end

end
