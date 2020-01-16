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

ActiveRecord::Schema.define(version: 2020_01_16_134548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instances", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_instances_on_name"
  end

  create_table "nodes", force: :cascade do |t|
    t.bigint "tree_id", null: false
    t.bigint "parent_id"
    t.string "name"
    t.text "description"
    t.string "node_type"
    t.string "node_subtype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_nodes_on_parent_id"
    t.index ["tree_id"], name: "index_nodes_on_tree_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "node_id", null: false
    t.string "name", null: false
    t.string "value_type", null: false
    t.text "value_string"
    t.integer "value_int"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["node_id"], name: "index_tags_on_node_id"
  end

  create_table "trees", force: :cascade do |t|
    t.bigint "instance_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["instance_id"], name: "index_trees_on_instance_id"
    t.index ["name"], name: "index_trees_on_name"
  end

  add_foreign_key "nodes", "nodes", column: "parent_id"
  add_foreign_key "nodes", "trees"
  add_foreign_key "tags", "nodes"
  add_foreign_key "trees", "instances"
end
