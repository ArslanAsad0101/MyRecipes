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

ActiveRecord::Schema[8.1].define(version: 2026_07_08_153000) do
  create_table "chefs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_chefs_on_email", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.integer "chef_id", null: false
    t.datetime "created_at", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["chef_id"], name: "index_comments_on_chef_id"
    t.index ["recipe_id"], name: "index_comments_on_recipe_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "chef_a_id"
    t.integer "chef_b_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chef_a_id", "chef_b_id"], name: "index_conversations_on_chef_a_id_and_chef_b_id", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "chef_id", null: false
    t.integer "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chef_id"], name: "index_messages_on_chef_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ingredient_id", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_likes", force: :cascade do |t|
    t.integer "chef_id"
    t.datetime "created_at", null: false
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.string "visitor_token"
    t.index ["chef_id"], name: "index_recipe_likes_on_chef_id"
    t.index ["recipe_id", "chef_id"], name: "index_recipe_likes_on_recipe_id_and_chef_id", unique: true
    t.index ["recipe_id", "visitor_token"], name: "index_recipe_likes_on_recipe_id_and_visitor_token", unique: true
    t.index ["recipe_id"], name: "index_recipe_likes_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "category"
    t.integer "chef_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "likes_count", default: 0, null: false
    t.string "time"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["chef_id"], name: "index_recipes_on_chef_id"
  end

  add_foreign_key "comments", "chefs"
  add_foreign_key "comments", "recipes"
  add_foreign_key "messages", "chefs"
  add_foreign_key "messages", "conversations"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_likes", "chefs"
  add_foreign_key "recipe_likes", "recipes"
  add_foreign_key "recipes", "chefs"
end
