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

ActiveRecord::Schema.define(version: 2024_05_29_043334) do

  create_table "nodes", force: :cascade do |t|
    t.string "name"
    t.integer "node_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "arch"
    t.integer "cores_per_socket"
    t.integer "cpu_alloc"
    t.integer "cpu_efctv"
    t.integer "cpu_tot"
    t.float "cpu_load"
    t.text "available_features"
    t.text "active_features"
    t.text "gres"
    t.string "node_addr"
    t.string "node_hostname"
    t.string "version"
    t.string "os"
    t.integer "real_memory"
    t.integer "alloc_mem"
    t.integer "free_mem"
    t.integer "sockets"
    t.integer "boards"
    t.integer "mem_spec_limit"
    t.string "state"
    t.integer "threads_per_core"
    t.integer "tmp_disk"
    t.integer "weight"
    t.string "owner"
    t.string "mcs_label"
    t.text "partitions"
    t.datetime "boot_time"
    t.datetime "slurmd_start_time"
    t.datetime "last_busy_time"
    t.datetime "resume_after_time"
    t.text "cfg_tres"
    t.text "alloc_tres"
    t.string "cap_watts"
    t.integer "current_watts"
    t.integer "ave_watts"
    t.string "ext_sensors_joules"
    t.integer "ext_sensors_watts"
    t.string "ext_sensors_temp"
  end

end
