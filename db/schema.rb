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

ActiveRecord::Schema.define(version: 2020_09_03_133831) do

  create_table "allocations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_allocations_on_created_at"
    t.index ["registration_id"], name: "index_allocations_on_registration_id"
    t.index ["resource_id"], name: "index_allocations_on_resource_id", unique: true
  end

  create_table "registrations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "barcode", null: false
    t.datetime "entered_at", null: false
    t.datetime "exited_at"
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid", null: false
    t.index ["barcode"], name: "index_registrations_on_barcode"
    t.index ["entered_at"], name: "index_registrations_on_entered_at"
    t.index ["exited_at"], name: "index_registrations_on_exited_at"
  end

  create_table "released_allocations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "released_at", null: false
    t.index ["created_at"], name: "index_released_allocations_on_created_at"
    t.index ["registration_id"], name: "index_released_allocations_on_registration_id"
    t.index ["released_at"], name: "index_released_allocations_on_released_at"
    t.index ["resource_id"], name: "index_released_allocations_on_resource_id"
  end

  create_table "reservations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "begin_date", null: false
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["begin_date"], name: "index_reservations_on_begin_date"
    t.index ["end_date"], name: "index_reservations_on_end_date"
    t.index ["resource_id"], name: "index_reservations_on_resource_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "resource_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resource_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "resource_group_id", null: false
    t.bigint "resource_location_id", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resource_group_id"], name: "index_resources_on_resource_group_id"
    t.index ["resource_location_id"], name: "index_resources_on_resource_location_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "allocations", "registrations"
  add_foreign_key "allocations", "resources"
  add_foreign_key "released_allocations", "registrations"
  add_foreign_key "released_allocations", "resources"
  add_foreign_key "reservations", "resources"
  add_foreign_key "reservations", "users", on_delete: :cascade
  add_foreign_key "resources", "resource_groups"
  add_foreign_key "resources", "resource_locations"
end
