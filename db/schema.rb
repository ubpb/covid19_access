# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_07_130304) do

  create_table "access_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ilsid", null: false
    t.string "direction", null: false
    t.datetime "timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["direction"], name: "index_access_logs_on_direction"
    t.index ["ilsid"], name: "index_access_logs_on_ilsid"
    t.index ["timestamp"], name: "index_access_logs_on_timestamp"
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ilsid", null: false
    t.datetime "entered_at", null: false
    t.datetime "exited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entered_at"], name: "index_people_on_entered_at"
    t.index ["exited_at"], name: "index_people_on_exited_at"
    t.index ["ilsid"], name: "index_people_on_ilsid"
  end

end
